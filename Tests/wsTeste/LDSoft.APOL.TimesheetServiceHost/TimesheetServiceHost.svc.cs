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
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class TimesheetServiceHost : ITimesheetServiceHost
    {
        public TimesheetDataContract Obter(int id)
        {
            //throw new NotImplementedException();
            return new TimesheetDataContract();
        }

        public IList<TimesheetDataContract> Listar(TimesheetDataContract item)
        {
            //throw new NotImplementedException();
            return new List<TimesheetDataContract>();
        }

        public TimesheetDataContract ObterJSON(string id)
        {
            return new TimesheetDataContract { Detalhe = "Teste Retorno", Valor = 200 };
        }
    }
}
