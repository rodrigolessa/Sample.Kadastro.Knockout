using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Linq;
using System.Text;

namespace LDSoft.APOL.TimesheetContracts
{
    [DataContract]
    public class TimesheetDataContract
    {
        private int _id = 1;
        // TODO: Refatorar para classe do tipo Processo
        private string _processo = "100.02136.12772";
        // TODO: Refatorar para classe do tipo Envolvido
        private string _envolvido = "1";
        // TODO: Refatorar para classe do tipo Responsável
        private string _responsavel = "1";
        private DateTime? _data = new DateTime(2013,12,18);
        private TimeSpan _hora = new TimeSpan(10, 10, 10);
        private bool _cobrar = true;
        private string _descricaoAtividade = "Atividade de Teste";
        private string _detalhe = "Descrição da atividade de Teste.";
        private decimal? _valor = 150;

        [DataMember]
        public int Id
        {
            get { return _id; }
            set { _id = value; }
        }

        [DataMember]
        public string Processo
        {
            get { return _processo; }
            set { _processo = value; }
        }

        [DataMember]
        public string Envolvido
        {
            get { return _envolvido; }
            set { _envolvido = value; }
        }

        [DataMember]
        public string Responsavel
        {
            get { return _responsavel; }
            set { _responsavel = value; }
        }

        [DataMember]
        public DateTime? Data
        {
            get { return _data; }
            set { _data = value; }
        }

        [DataMember]
        public TimeSpan Hora
        {
            get { return _hora; }
            set { _hora = value; }
        }

        [DataMember]
        public bool Cobrar
        {
            get { return _cobrar; }
            set { _cobrar = value; }
        }

        [DataMember]
        public string DescricaoAtividade
        {
            get { return _descricaoAtividade; }
            set { _descricaoAtividade = value; }
        }

        [DataMember]
        public string Detalhe
        {
            get { return _detalhe; }
            set { _detalhe = value; }
        }

        [DataMember]
        public decimal? Valor
        {
            get { return _valor; }
            set { _valor = value; }
        }
    }
}
