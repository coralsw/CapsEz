notepad_trim:
	send,^c<code>{Blind}^v</code>
return

notepad_cleanWhitespace:
	send,^c<code>{Blind}^v</code>
return

write_trim:
	send,^c<code>{Blind}^v</code>
return


excel_SortPowerTable:
	ControlClick,Edit1,A
	sleep,100
	Send,A3:H40{Enter}
	Sleep,100
	Send,!hss
return

