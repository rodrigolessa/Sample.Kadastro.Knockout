<%

Const LIBERADO_VALOR = "L"		'Usuário ativo no sistema'
Const TESTE_VALOR = "T"			'Usuário utilizando o sistema por um período de testes'
Const BLOQUEADO_VALOR = "B"		'Usuário sem acesso ao sistema (por motivo de pagamento por exemplo)'
Const INADIMPLENTE_VALOR = "I"		'Usuário sem acesso ao sistema (por motivo de pagamento por exemplo)'

Const LIBERADO_INADIMPLENTE_VALOR = "LI"
Const BLOQUEADO_INADIMPLENTE_VALOR = "BI"

Const LIBERADO_DESCRICAO = "Liberado"
Const TESTE_DESCRICAO = "Teste"
Const BLOQUEADO_DESCRICAO = "Bloqueado"
Const INADIMPLENTE_DESCRICAO = "Inadimplente"

Const LIBERADO_COR = "#99ff99"
Const TESTE_COR = "#ffff66"
Const INADIMPLENTE_COR = "#FF9933"
Const BLOQUEADO_COR = "#ff6666"

Class cStatusUsuario

	Private m_List

	Sub Class_Initialize()
		Set m_List = Server.CreateObject("Scripting.Dictionary")
		
	End Sub

	Sub Class_Terminate()
		m_List = Nothing
	End Sub

	Public Function GetAll()

		m_List.Add LIBERADO_VALOR, LIBERADO_DESCRICAO
		m_List.Add TESTE_VALOR, TESTE_DESCRICAO
		m_List.Add BLOQUEADO_VALOR, BLOQUEADO_DESCRICAO

		Set GetAll = m_List
	End Function

	'Obtem a lista apenas de status usados para inadimplencia'
	Public Function GetAllFluxoDeInadimplencia()

		m_List.Add LIBERADO_VALOR, LIBERADO_DESCRICAO
		m_List.Add INADIMPLENTE_VALOR, INADIMPLENTE_DESCRICAO
		m_List.Add BLOQUEADO_VALOR, BLOQUEADO_DESCRICAO		

		Set GetAllFluxoDeInadimplencia = m_List
	End Function

	Function ObterCorPorStatus(p_Status)

        Dim cor

        select case ucase(p_Status)
            case LIBERADO_VALOR
                cor = LIBERADO_COR
            case TESTE_VALOR
                cor = TESTE_COR
            case BLOQUEADO_VALOR
                cor = BLOQUEADO_COR
            case INADIMPLENTE_VALOR
                cor = INADIMPLENTE_COR
            case else 
                cor = BLOQUEADO_COR ' Coluna "status_apol" NULL or VAZIO
        end select

        ObterCorPorStatus = cor

    End Function

End Class

%>