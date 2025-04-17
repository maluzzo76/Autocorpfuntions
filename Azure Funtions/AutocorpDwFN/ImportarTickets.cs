using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Net.Http.Headers;
using System.Text;


namespace AutocorpDwFN
{
    public class ImportarTickets
    {
        private string _sqlConectionString = "Server=tcp:autocorpdw.database.windows.net,1433;Initial Catalog=Autocorp_dw;Persist Security Info=False;User ID=Autocorp;Password=Alusoft2420;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        private readonly ILogger<ImportarTickets> _logger;

        public ImportarTickets(ILogger<ImportarTickets> logger)
        {
            _logger = logger;
        }

        [Function("ImportarTickets")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            string apiKey = "yBjVC7W3wuMLeucdH4Hw"; // Reemplaza por tu API Key real
            int perPage = 10;
            int page = 1;
            HttpClient httpClient = new HttpClient();

            _logger.LogInformation("Azure Function 'ImportarTickets' inició el proceso.");

            try
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($"{apiKey}:X")));

                DataTable ticketDataTable = new DataTable();
                ticketDataTable.Columns.Add("codigo", typeof(Int32));
                ticketDataTable.Columns.Add("fechaAlta", typeof(DateTime));
                ticketDataTable.Columns.Add("fechaModificacion", typeof(DateTime));
                ticketDataTable.Columns.Add("horasDiferencia", typeof(string));
                ticketDataTable.Columns.Add("minutosDiferencia", typeof(string));
                ticketDataTable.Columns.Add("companiaCodigo", typeof(string));
                ticketDataTable.Columns.Add("estadoCodigo", typeof(string));
                ticketDataTable.Columns.Add("tipoCodigo", typeof(string));
                ticketDataTable.Columns.Add("productoCodigo", typeof(string));
                ticketDataTable.Columns.Add("grupoCodigo", typeof(string));
                ticketDataTable.Columns.Add("origenCodigo", typeof(string));
                ticketDataTable.Columns.Add("prioridadCodigo", typeof(string));
                ticketDataTable.Columns.Add("agenteCodigo", typeof(string));

                string fechaDesde = req.Query["fechaDesde"];
                if (fechaDesde != null)
                {
                    DateTime _startDate = DateTime.Parse(fechaDesde, null, System.Globalization.DateTimeStyles.RoundtripKind); 

                    //for (DateTime currentDate = _startDate; currentDate < DateTime.Now.AddDays(1); currentDate = currentDate.AddDays(1))
                    //{
                        bool hasMorePages = true;
                        page = 1;

                        while (hasMorePages)
                        {
                            string filterDate = $"{_startDate:yyyy-MM-dd}";
                            string url = $"https://autocorpar.freshdesk.com/api/v2/search/tickets?query=\"created_at:'{filterDate}'\"&page={page}";

                            HttpResponseMessage response = httpClient.GetAsync(url).Result;

                            if (!response.IsSuccessStatusCode)
                            {
                                _logger.LogWarning($"Falló la respuesta para la fecha {filterDate}, código: {response.StatusCode}");
                                break;
                            }

                            string responseBody = response.Content.ReadAsStringAsync().Result;

                            try
                            {
                                var jObject = JObject.Parse(responseBody);
                                var results = jObject["results"];
                                int totalItems = (int)jObject["total"];

                                foreach (var item in results)
                                {
                                    DataRow _drNew = ticketDataTable.NewRow();


                                    _drNew["codigo"] = (int)item["id"];
                                    _drNew["fechaAlta"] = (DateTime?)item["created_at"];
                                    _drNew["fechaModificacion"] = (DateTime?)item["updated_at"];
                                    _drNew["companiaCodigo"] = (string)item["company_id"];
                                    _drNew["estadoCodigo"] = (string)item["status"];
                                    _drNew["tipoCodigo"] = (string)item["type"];
                                    _drNew["productoCodigo"] = (string)item["product_id"];
                                    _drNew["grupoCodigo"] = (string)item["group_id"];
                                    _drNew["origenCodigo"] = (string)item["source"];
                                    _drNew["prioridadCodigo"] = (string)item["priority"];
                                    _drNew["agenteCodigo"] = (string)item["responder_id"];


                                    ticketDataTable.Rows.Add(_drNew);
                                    _logger.LogInformation($"Se obtuvo el tikets {_drNew["codigo"].ToString()}.");
                                }

                                hasMorePages = results.HasValues && results.Count() == perPage;
                                page++;
                            }
                            catch (Exception ex)
                            {
                                _logger.LogError($"Error procesando JSON: {ex.Message}");
                                throw ex;
                            }
                        }
                    //}

                    InsertTickets(ticketDataTable, _startDate);
                    _logger.LogInformation($"Proceso finalizado. Se procesaron {ticketDataTable.Rows.Count} tickets.");
                }
                return new OkObjectResult("ok");
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error general al importar tickets: {ex.Message}");
                return new StatusCodeResult(500);
            }
        }

        internal void InsertTickets(DataTable tickets, DateTime startDate)
        {
            SqlConnection _sconn = new SqlConnection(_sqlConectionString);
            try
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = _sconn;
                    cmd.CommandText = $"delete stg.Tickets where year(fechaAlta) ={startDate.Year} and Month(fechaAlta) = {startDate.Month} and day(fechaAlta) = {startDate.Day}";
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();
                }

                if (_sconn.State == ConnectionState.Open)
                {
                    _sconn.Close();
                }

                using (SqlBulkCopy _copy = new SqlBulkCopy(_sconn))
                {
                    _sconn.Open();
                    _copy.BulkCopyTimeout = 360;
                    _copy.DestinationTableName = "stg.Tickets";
                    _copy.WriteToServer(tickets);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
      

    public class Ticket
    {
        public int? codigo { get; set; }
        public DateTime? fechaAlta { get; set; }
        public DateTime? fechaModificacion { get; set; }
        public string? companiaCodigo { get; set; }
        public string? estadoCodigo { get; set; }
        public string? tipoCodigo { get; set; }
        public string? productoCodigo { get; set; }
        public string? grupoCodigo { get; set; }
        public string? origenCodigo { get; set; }
        public string? prioridadCodigo { get; set; }
        public string? agenteCodigo { get; set; }
    }
}
