<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%> 
<!--#include file="./classes/PayResponseHandler.asp"-->
<!--#include file="./classes/NotifyResponseHandler.asp"-->
<%
'---------------------------------------------------------
'�Ƹ�ͨ��ʱ���ʴ���ص�ʾ�����̻����մ�ʾ�����п�������
'---------------------------------------------------------

'��Կ
Dim key
key = "8934e7d15453e97507ef794cf7b0519d"

'����֧��Ӧ�����
Dim resHandler
Set resHandler = new PayResponseHandler
resHandler.setKey(key)

'�ж�ǩ��
If resHandler.isTenpaySign() = True Then
	
	Dim transaction_id
	Dim total_fee
	Dim out_trade_no
	Dim discount
	Dim trade_state
	
	'�̻����׵���
	out_trade_no = resHandler.getParameter("out_trade_no")	

	'�Ƹ�ͨ���׵���
	transaction_id = resHandler.getParameter("transaction_id")
	
	'֧�����
	trade_state = resHandler.getParameter("trade_state")
	trade_mode = resHandler.getParameter("trade_mode")
	notify_id = resHandler.getParameter("notify_id")
	
	partner = resHandler.getParameter("partner")
	
	If "0" = trade_state and "1" = trade_mode Then
		'��ʹ��notify_idȥ��ѯ�Ƹ�ͨ��������ȷ��֧���ɹ�
		Dim tenNotifyURL
		Dim sign
		Dim sign_str
		tenNotifyURL = "https://gw.tenpay.com/gateway/verifynotifyid.xml?"
		sign_str = "notify_id=" & notify_id & "&partner=" & partner & "&key=" & key
		sign = LCase(ASP_MD5(sign_str))
		
		tenNotifyURL = tenNotifyURL &"notify_id=" & notify_id & "&partner=" & partner & "&sign=" & sign
		'Response.Write("<br/>tenpay notify URL: " & tenNotifyURL & "<br/>")
		Set Retrieval = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		
		Retrieval.setOption 2, 13056 
		Retrieval.open "GET", tenNotifyURL, False, "", "" 
		Retrieval.send()
		
		'�ĵ��Ѿ�������ϣ��ͻ��˿��Խ��ܷ�����Ϣ
		If Retrieval.Readystate =4 Then
			If 200 = Retrieval.Status Then
				ResponseTxt = Retrieval.ResponseText
				'�½�������XMLDOM�ĵ���������
				Set xmlDoc = server.CreateObject("Microsoft.XMLDOM")
				'�������󷵻ص�XML�ĵ�
				xmlDoc.loadxml(ResponseTxt)
				Set notifyResp = new NotifyResponseHandler
				notifyResp.setKey(key)
				'��ȡ�ĵ���Ԫ��
				Set obj =  xmlDoc.selectSingleNode("root")
				'����root�������ӽڵ㣬��ȡ���صļ�ֵ��
				For Each node in obj.childnodes
					notifyResp.setParameter node.nodename, node.text 
					'Response.Write("<br/>" & node.nodename & "=" & node.text & "<br/>")
				Next
				'Response.Write("<br/>ResponseTxt: " & ResponseTxt & "<br/>")
				Set Retrieval = Nothing
				
				trade_state = notifyResp.getParameter("trade_state")
				trade_mode = notifyResp.getParameter("trade_mode")	
				
				'��Ʒ���,�Է�Ϊ��λ
				total_fee = notifyResp.getParameter("total_fee")
				
				'�����ʹ���ۿ�ȯ��discount��ֵ��total_fee+discount=ԭ�����total_fee
				discount = notifyResp.getParameter("discount")
	
				'�ж�notify��Ӧ��ǩ��
				If notifyResp.isTenpaySign() and "0" = notifyResp.getParameter("retcode") and "0" = trade_state and "1" = trade_mode Then
					'Response.Write("<br/>��ѯ֪ͨǩ����֤�ɹ�<br/>")
					'------------------------------
					'ȷ��������֧���ɹ�������ҵ��ʼ
					'------------------------------
					
					'ע�⽻�׵���Ҫ�ظ�����
					
					'ע���жϷ��ؽ��
					
					'------------------------------
					'����ҵ�����
					'------------------------------	
					
					'����ɹ�
					'���ظ��Ƹ�ͨ��������Ϣ���ظ�֪ͨ��ʱ��ֱ�ӷ���success
					Response.Write("success")
				Else
					'�ǲƸ�֪ͨͨ��notify_id��ʱ,�ο�recode��ֵ��retmsg��ȷ��ԭ��, �������ɹ�����
					Response.Write("<br/>��ѯ֪ͨǩ����֤ʧ��<br/>")
					notifyDebugInfo = notifyResp.getDebugInfo()
					Response.Write("<br/>retcode: " & notifyResp.getParameter("retcode") & "<br/>")
					Response.Write("<br/>retmsg: " & notifyResp.getParameter("retmsg") & "<br/>")
					Response.Write("<br/>Debug info: " & notifyDebugInfo & "<br/>")
				End If
			Else 
				'�������Ӵ���Http�����벻��200����ѯnotify_idʧ�ܣ���¼�����ź���־���Ժ���Ե��ò�ѯ�����ӿ�
				Response.Write("<br/>Http code: " & Retrieval.Status & "<br/>")
				Response.Write("<br/> �������Ӵ��󣬶�����Ϊ��" + transaction_id)
			End if
		Else 
			'�������Ӵ��󣬲�ѯnotify_idʧ�ܣ���¼�����ź���־���Ժ���Ե��ò�ѯ�����ӿ�
			Response.Write("<br/> �������Ӵ��󣬶�����Ϊ��" + transaction_id)
		End if
	Else
		'�������ɹ�����
		Response.Write("֧��ʧ��")
		Response.Write("<br/>trade_state:" & trade_state & "<br/>")
		Response.Write("<br/>pay_info:" & resHandler.getParameter("pay_info") & "<br/>")
		
	End If	

Else

	'ǩ��ʧ��
	Response.Write("ǩ��ǩ֤ʧ��")
	Dim debugInfo
	debugInfo = resHandler.getDebugInfo()
	Response.Write("<br/>debugInfo:" & debugInfo & "<br/>")

End If
%>