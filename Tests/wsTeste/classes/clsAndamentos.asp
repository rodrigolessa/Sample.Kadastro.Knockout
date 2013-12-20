<%
'--------------------------------------------------------------------------'
'Author: Michele Silva
'Create: 2013-10-24
'
'Dependences Parameters: 
'	N/A
'
'Dependences Files: 
'	/include/adovbs.inc
'	/include/helpers/inc_ADOHelper.asp
'	/include/conn.asp
'
'Methods:
'	Sub Class_Initialize
'	Sub Class_Terminate
'
'--------------------------------------------------------------------------'

Class clsAndamentos

	 
	Private m_id	
	Private m_idProcesso	
	Private m_descricaoAndamento	
	Private m_data	
	Private m_protocolo	
	Private m_descricao	
	Private m_descricaoOutroIdioma	
	Private m_detalheOutroIdioma	
	Private m_idioma	
	Private m_ocultar	
	Private m_historicoIsisFk	

	Public Property Get Id()
		Id = m_id
	End Property

	Public Property Let Id(p_Data)
		m_id = p_Data
	End Property
	'==========================================='
	Public Property Get IdProcesso()
		IdProcesso = m_idProcesso
	End Property

	Public Property Let IdProcesso(p_Data)
		m_idProcesso = p_Data
	End Property
	'========================================='
	Public Property Get DescricaoAndamento()
		DescricaoAndamento = m_descricaoAndamento
	End Property

	Public Property Let DescricaoAndamento(p_Data)
		m_descricaoAndamento = p_Data
	End Property
	'========================================='
	Public Property Get Data()
		Data = m_data
	End Property

	Public Property Let Data(p_Data)
		m_data = p_Data
	End Property
	'======================================='
	Public Property Get Protocolo()
		Protocolo = m_protocolo
	End Property

	Public Property Let Protocolo(p_Data)
		m_protocolo = p_Data
	End Property
	'========================================'
	public Property Get Descricao()
		Descricao = m_descricao
	End Property

	Public Property Let Descricao(p_Data)
		m_descricaoOutroIdioma = p_Data
	End Property
	'================================================'
	public Property Get DescricaoOutroIdioma()
		DescricaoOutroIdioma = m_descricaoOutroIdioma 
	End Property

	Public Property Let DescricaoOutroIdioma(p_Data)
		m_descricaoOutroIdioma = p_Data
	End Property
	'==========================================='
	public Property Get Idioma()
		Idioma  = m_idioma
	End Property

	Public Property Let Idioma(p_Data)
		m_idioma = p_Data
	End Property
	'=================================='
	public Property Get Ocultar()
		Ocultar  = m_ocultar
	End Property

	Public Property Let Ocultar(p_Data)
		m_ocultar = p_Data
	End Property
	'=============================================='
	public Property Get HistoricoIsis()
		HistoricoIsis  = m_historicoIsisFk
	End Property

	Public Property Let HistoricoIsis(p_Data)
		m_historicoIsisFk = p_Data
	End Property


	public Function ExisteAndamentoProcesso()

		existeAndamento = false 

		if len(trim(Me.IdProcesso)) > 0 then

			sql = "SELECT COUNT(id_processo) FROM [Contencioso].[dbo].[tb_Andamentos] WHERE id_processo = " & Me.IdProcesso

			set rs = db.execute(sql)

			if (not rs.EOF) then
				if (rs(0) > 0) then
					existeAndamento = true
				end if 
			end if

		end if

		ExisteAndamentoProcesso = existeAndamento

	end function
	
end class
%>