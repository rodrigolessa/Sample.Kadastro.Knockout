using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using LDSoft.APOL.TimesheetContracts;

namespace LDSoft.APOL.TimesheetServiceHost
{
    [ServiceContract]
    public interface ITimesheetServiceHost
    {
        [OperationContract]
        TimesheetDataContract Obter(int id);

        [OperationContract]
        IList<TimesheetDataContract> Listar(TimesheetDataContract item);

        // TODO: Adicionar operações do serviço

        [OperationContract]
        [WebGet(UriTemplate = "ObterJSON", ResponseFormat = WebMessageFormat.Json)]
        TimesheetDataContract ObterJSON(string id);
    }
}
