using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json.Linq;
using Azure;
using System.IO;
using System.Threading.Tasks;
using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;
using System.ComponentModel;
using System.Diagnostics;

namespace dwservices
{
    public class ActivityFileImport
    {
        private string _sqlConectionString = "Server=tcp:autocorpdw.database.windows.net,1433;Initial Catalog=Autocorp_dw;Persist Security Info=False;User ID=Autocorp;Password=Alusoft2420;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        private string _AzureStorageConnetion = "DefaultEndpointsProtocol=https;AccountName=storagefreshdesk;AccountKey=CLKKxXUFClT8HMtz9tw/XEkW6q6echRg7aUjl0JbihHH+PCpP9z61zCn95vCarvKJvJ1/UGd0eD2+AStPHm0wQ==;EndpointSuffix=core.windows.net";
        private readonly ILogger<Function1> _logger;

        public ActivityFileImport(ILogger<Function1> logger)
        {
            _logger = logger;
        }

        [Function("ImporFileActivity")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                string connectionFileShared = _AzureStorageConnetion;
                string shareName = "freshdesk-activities"; // nombre del recurso compartido
                string targetFolder = "procesados";

                var shareClient = new ShareClient(connectionFileShared, shareName);
                var directoryClient = shareClient.GetRootDirectoryClient();
                var rootDir = shareClient.GetRootDirectoryClient();

                foreach (ShareFileItem item in directoryClient.GetFilesAndDirectories())
                {
                    if (item.IsDirectory)
                    {
                        ShareDirectoryClient subDir = directoryClient.GetSubdirectoryClient(item.Name);
                        ShareDirectoryClient targetDir = rootDir.GetSubdirectoryClient($"{targetFolder}"); 
                        ShareDirectoryClient targetDir1 = rootDir.GetSubdirectoryClient($"{targetFolder}/{item.Name}");



                        //Crea la carpeta destino si no existe
                        targetDir.CreateIfNotExists();
                        targetDir1.CreateIfNotExists();

                        foreach (ShareFileItem file in subDir.GetFilesAndDirectories())
                        {
                            if (file.Name.EndsWith(".json", StringComparison.OrdinalIgnoreCase))
                            {
                                ShareFileClient fileClient = subDir.GetFileClient(file.Name);
                                var download = fileClient.Download();
                                using var reader = new StreamReader(download.Value.Content);
                                string jsonContent = reader.ReadToEnd();

                                DataTable _dtActivity = ParseJsonToDataTable(jsonContent);
                                InsertActitity(_dtActivity);

                                //Copia archivo al nuevo directorio
                                ShareFileClient targetFile = targetDir1.GetFileClient(file.Name);
                                targetFile.Create(fileClient.GetProperties().Value.ContentLength);

                                targetFile.DeleteIfExists();
                                targetDir1.CreateIfNotExists();
                                targetFile.StartCopy(fileClient.Uri);

                                // Esperar que se copie antes de borrar
                                while (true)
                                {
                                    var properties =  targetFile.GetProperties();
                                    if (properties.Value.CopyStatus != CopyStatus.Pending)
                                        break;

                                     Task.Delay(200); // espera corta
                                }

                                // Borrar archivo original
                                fileClient.DeleteIfExists();
                            }
                        }

                    }
                }

                return new OkObjectResult("ok");
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al llamar la API: {ex.Message}");
                return new StatusCodeResult(500);
            }
        }


        internal DataTable ParseJsonToDataTable(string jsonContent)
        {
            var jObject = JObject.Parse(jsonContent);

            var table = new DataTable("Activities");

            string[] columns = new[]
            {
            "performed_at", "ticket_id", "performer_type", "performer_id",
            "activity.note.id", "activity.note.type", "activity.status", "activity.requester_id",
            "activity.source", "activity.group", "activity.priority", "activity.new_ticket",
            "activity.automation.type", "activity.automation.rule", "activity.added_tags",
            "activity.agent_id", "activity.ID eFleet", "activity.Obs eFleet",
            "activity.send_email.agent_ids", "activity. Patente", "activity.ticket_type",
            "activity.description", "activity.subject", "activity.Kilometraje",
            "activity.Generar OT - eFleet", "activity.due_by", "activity.Fecha turno",
            "activity.association.action", "activity.association.type",
            "activity.association.source_ticket_id", "activity.association.target_ticket_id",
            "activity.deleted", "activity.Fecha primer turno", "activity.product"
        };

            foreach (var col in columns)
                table.Columns.Add(col, typeof(string));

            var activities = jObject["activities_data"];
            if (activities == null) return table;

            foreach (var item in activities)
            {
                var row = table.NewRow();

                foreach (var col in columns)
                {
                    string[] path = col.Split('.');
                    JToken current = item;

                    foreach (var part in path)
                    {
                        if (current == null) break;
                        current = current[part];
                    }

                    row[col] = current?.ToString() ?? DBNull.Value.ToString();
                }

                table.Rows.Add(row);
            }

            return table;
        }

        internal void InsertActitity(DataTable _dt)
        {
            SqlConnection _sconn = new SqlConnection(_sqlConectionString);

            using (SqlBulkCopy _copy = new SqlBulkCopy(_sconn))
            {
                _sconn.Open();
                _copy.DestinationTableName = "stg.ActivityLogs";
                _copy.WriteToServer(_dt);
            }
        }
    }
}
