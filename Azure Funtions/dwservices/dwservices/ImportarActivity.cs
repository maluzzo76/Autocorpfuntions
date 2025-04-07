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
using Azure;

namespace dwservices
{
    public class ImportarActivity
    {
        private string _sqlConectionString = "Server=tcp:autocorpdw.database.windows.net,1433;Initial Catalog=Autocorp_dw;Persist Security Info=False;User ID=Autocorp;Password=Alusoft2420;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        private readonly ILogger<Function1> _logger;

        public ImportarActivity(ILogger<Function1> logger)
        {
            _logger = logger;
        }

        [Function("ImportarActivity")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                //Api Connection 
                HttpClient httpClient = new HttpClient();
                string apiKey = "yBjVC7W3wuMLeucdH4Hw";
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($"{apiKey}:X")));

                string apiUrl = $"https://autocorpar.freshdesk.com/api/v2/export/ticket_activities";

                HttpResponseMessage response = httpClient.GetAsync(apiUrl).Result; // Bloqueante
                response.EnsureSuccessStatusCode(); // Lanza excepción si hay error
                string responseData = response.Content.ReadAsStringAsync().Result; // Bloqueante
                var jObject = JObject.Parse(responseData);

                if (responseData != "[]")
                {
                    var _data = jObject["export"][0]["url"];
                }

                return new OkObjectResult("ok");
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al llamar la API: {ex.Message}");
                return new StatusCodeResult(500);
            }
        }       
    }
}
