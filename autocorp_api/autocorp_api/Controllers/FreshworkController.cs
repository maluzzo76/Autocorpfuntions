using System.Net.Http.Headers;
using System.Net.Sockets;
using System.Text.Json;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System;
using System.Data;
using System.Data.SqlClient;
using Newtonsoft.Json;
using System.Transactions;
using System.Collections;

namespace autocorp_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FreshworkController : ControllerBase
    {
        private readonly HttpClient _client;

        public FreshworkController()
        {
            _client = new HttpClient();
            string apiKey = "yBjVC7W3wuMLeucdH4Hw";  // ⚠️ No expongas la API Key en código fuente
            _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic",
                Convert.ToBase64String(Encoding.ASCII.GetBytes($"{apiKey}:X")));
        }

        [HttpGet("tickets")]
        public async Task<IList<Ticket>> InsertTicket()
        {
            IList<Ticket> tickets = new List<Ticket>();

            try
            {
                string freshdeskDomain = "/autocorpar.freshdesk.com";  // Cambia por tu dominio de Freshdesk
                string apiKey = "yBjVC7W3wuMLeucdH4Hw";
                int perPage = 30;  // Máximo permitido por Freshdesk
                int page = 1;  // Página inicial

                using HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(Encoding.ASCII.GetBytes($"{apiKey}:X")));

                bool hasMorePages = true;
                int item = 0;

                for (DateTime _date= DateTime.Now.AddYears(-1); _date < DateTime.Now.AddDays(1); _date = _date.AddDays(1))
                {
                    hasMorePages = true;
                    item = 0;
                    page = 1;

                    while (hasMorePages)
                    {
                        string filterdate = $"{_date.Year}-{_date.Month.ToString().PadLeft(2,char.Parse("0")) }-{_date.Day.ToString().PadLeft(2, char.Parse("0"))}";
                        // string url = $"https://autocorpar.freshdesk.com/api/v2/tickets?page={page}&per_page={perPage}";
                        string url = $"https://autocorpar.freshdesk.com/api/v2/search/tickets?query='created_at:%27{filterdate}%27'&page={page}".Replace("'","\"");


                        HttpResponseMessage response = await client.GetAsync(url);
                        response.EnsureSuccessStatusCode();

                        string _responseBody = await response.Content.ReadAsStringAsync();

                        try
                        {
                            var jObjectR = JObject.Parse(_responseBody);
                            //var jObject = JArray.Parse((string));
                            var totalItems = (int)jObjectR["total"];

                            foreach (var _item in jObjectR["results"])
                            {
                                item++;
                                Ticket _ticket = new Ticket();

                                _ticket.codigo = (int)_item["id"];
                                _ticket.fechaAlta = (DateTime)_item["created_at"];
                                _ticket.fechaModificacion = (DateTime)_item["updated_at"];
                                _ticket.companiaCodigo = (string)_item["company_id"];
                                _ticket.estadoCodigo = (string)_item["status"];
                                _ticket.tipoCodigo = (string)_item["type"];
                                _ticket.productoCodigo = (string)_item["product_id"];
                                _ticket.grupoCodigo = (string)_item["group_id"];
                                _ticket.origenCodigo = (string)_item["source"];
                                _ticket.prioridadCodigo = (string)_item["priority"];
                                _ticket.agenteCodigo = (string)_item["responder_id"];
                                if (_ticket.fechaAlta.Value.Year < 2025)
                                {
                                    var _j = true;
                                }
                                tickets.Add(_ticket);
                            }


                            if (item < perPage)
                                hasMorePages = false;
                            else
                            {
                                page++; // Avanzar a la siguiente página
                                item = 0;
                            }

                        }
                        catch (Exception ex)
                        {
                            var _err = ex;
                        }

                    }
                }

            }            
            catch (HttpRequestException e)
            {
                throw e;
            }

            //string json = JsonConvert.SerializeObject(dtTickets);

            return tickets;// Ok(json);  // Retornar la respuesta de Freshdesk
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
