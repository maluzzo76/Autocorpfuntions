using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json.Linq;

namespace dwservices
{
    public class Function1
    {

        private string _sqlConectionString = "Server=tcp:autocorpdw.database.windows.net,1433;Initial Catalog=Autocorp_dw;Persist Security Info=False;User ID=Autocorp;Password=Alusoft2420;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        private readonly ILogger<Function1> _logger;

        public Function1(ILogger<Function1> logger)
        {
            _logger = logger;
        }

        [Function("ImportarConversaciones")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");


            DataTable _dtTickets = new DataTable();

            DataTable _conversaciones = new DataTable();
            _conversaciones.Columns.Add("id");
            _conversaciones.Columns.Add("created_at");
            _conversaciones.Columns.Add("updated_at");


            string _query = "SELECT * FROM whs.v_getConversaciones";
           

            // Obtengo los 50 tickets sin fecha de Respuesta
            using (SqlConnection conn = new SqlConnection(_sqlConectionString))
            {
                conn.Open();
                using (SqlDataAdapter adapter = new SqlDataAdapter(_query, conn))
                {
                    adapter.Fill(_dtTickets);
                }
            }


            // Busca la fecha de respuesta en la api de fresh y la asigna el tickets
            int _IndexCount = 0;
            try
            {
                foreach (DataRow _tickets in _dtTickets.Rows)
                {
                    HttpClient httpClient = new HttpClient();
                    try
                    {

                        string apiKey = "yBjVC7W3wuMLeucdH4Hw";
                        httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($"{apiKey}:X")));

                        string apiUrl = $"https://autocorpar.freshdesk.com/api/v2/tickets/{_tickets[0].ToString()}/conversations";

                        HttpResponseMessage response = httpClient.GetAsync(apiUrl).Result; // Bloqueante
                        response.EnsureSuccessStatusCode(); // Lanza excepción si hay error

                        string responseData = response.Content.ReadAsStringAsync().Result; // Bloqueante
                        var jObject = JArray.Parse(responseData);

                        if (responseData != "[]")
                        {
                            DataRow _new = _conversaciones.NewRow();

                            _new[0] = _tickets[0].ToString();
                            _new[1] = (DateTime)jObject[0]["created_at"];
                            _new[2] = (DateTime)jObject[0]["updated_at"];

                            _conversaciones.Rows.Add(_new); ;
                        }

                        if (_IndexCount == 50 && _conversaciones.Rows.Count >0)
                        {
                            _conversaciones = InsertConversaciones(_conversaciones);
                            _IndexCount = 0;
                        }
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;
                    }
                    finally {
                        httpClient.Dispose();
                    }

                    _IndexCount++;
                }

                if (_conversaciones.Rows.Count > 0)
                {
                    _conversaciones = InsertConversaciones(_conversaciones);
                }


                return new OkObjectResult("ok");

                
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al llamar la API: {ex.Message}");
                return new StatusCodeResult(500);
            }
        }

        private DataTable InsertConversaciones(DataTable _dt)
        {
            DataTable _dtNew = new DataTable();
            _dtNew.Columns.Add("id");
            _dtNew.Columns.Add("created_at");
            _dtNew.Columns.Add("updated_at");

            SqlConnection _sconn = new SqlConnection(_sqlConectionString);

            using (SqlBulkCopy _copy = new SqlBulkCopy(_sconn))
            {
                _sconn.Open(); 
                _copy.DestinationTableName = "stg.Conversaciones";
                _copy.WriteToServer(_dt);

               return _dtNew;
            }

            return _dt;
        }
      
    }
}
