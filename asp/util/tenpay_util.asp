<%

'��ȡʱ���ַ���, ��ʽYYYYMMDDhhmiss
Public Function getStrNow()
	strNow = Now()
	strNow = Year(strNow) & Right(("00" & Month(strNow)),2) & Right(("00" & Day(strNow)),2) & Right(("00" & Hour(strNow)),2) & Right(("00" &  Minute(strNow)),2) & Right(("00" & Second(strNow)),2)
	getStrNow = strNow
End Function


' ��ȡ���������ڣ���ʽYYYYMMDD
Public Function getServerDate()
	getServerDate = Left(getStrNow,8)
End Function

'��ȡʱ��,��ʽhhmiss ��:192030
Public Function getTime()
	getTime = Right(getStrNow,6)
End Function

'��ȡ�����,���� [min,max]��Χ����
Public Function getRandNumber(max, min)
	Randomize 
	getRandNumber = CInt((max-min+1)*Rnd()+min) 
End Function

'��ȡ������ֵ��ַ���,����[min,max]��Χ�������ַ���
Public Function getStrRandNumber(max, min)
	randNumber = getRandNumber(max, min)
	getStrRandNumber = CStr(randNumber)
End Function




%>