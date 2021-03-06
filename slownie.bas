rem Makro kwota słownie, ver 1.5
rem (C) 2008, Jan Słupski, jslupski@juljas.net
rem http://juljas.net/linux/tips/openoffice.html
rem
rem Licencja: GNU LGPL version 2.1
rem http://www.gnu.org/licenses/lgpl-2.1.html
rem
rem Dodać makro można tak: MENU->Narzędzia->Makra->Zarządzaj Makrami->Makro
rem Wybrać Moje makra->Standard, nacisnąć "Nowy" i w oknie wkleić tę treść
rem 
rem Działają makra:
rem =SLOWNIE(123)
rem =SLOWNIEZL(123)
rem =SLOWNIEZL100GR(123)
rem
rem Zakres liczb - od -999 999 999,99 do 999 999 999,99
rem 
rem Nie działają:
rem - części ułamkowe w wersji SLOWNIE()
rem - zapis groszy/części ułamkowej w postaci słownej
rem - liczby >= 1 000 000 000 (łatwo poprawić/dopisać)
rem

sub slownie1(numer) as string
	dim s as string
	select case numer
		Case 0 
			s = ""
		Case 1 
			s = "jeden"
		Case 2 
			s = "dwa"
		Case 3 
			s = "trzy"
		Case 4 
			s = "cztery"
		Case 5 
			s = "pięć"
		Case 6 
			s = "sześć"
		Case 7 
			s = "siedem"
		Case 8 
			s = "osiem"
		Case 9 
			s = "dziewięć"
	End Select
	Slownie1 = s
End Sub

sub Slownie10(numer) as string
	dim s as string
	select case numer
		Case 0 
			s = ""
		Case 1 
			s = "dziesięć"
		Case 2 
			s = Slownie1(numer) & "dzieścia"
		Case 3
			s = Slownie1(numer) & "dzieści"
		Case 4 
			s = "czterdzieści"
		Case 5 to 9
			s = Slownie1(numer) & "dziesiąt"
	End Select
	Slownie10 = s
End Sub

sub slownie19(numer) as string
	dim s as string
	select case numer
		Case 0 
			s = "dziesięć"
		Case 1 
			s = "jedenaście"
		Case 2 
			s = "dwanaście"
		Case 3 
			s = "trzynaście"
		Case 4 
			s = "czternaście"
		Case 5 
			s = "piętnaście"
		Case 6 
			s = "szesnaście"
		Case 7 
			s = "siedemnaście"
		Case 8 
			s = "osiemnaście"
		Case 9 
			s = "dziewiętnaście"
	End Select
	Slownie19 = s
End Sub

sub Slownie100(numer) as string
	dim s as string
	select case numer
		Case 0 
			s = ""
		Case 1 
			s = "sto"
		Case 2 
			s = "dwieście"
		Case 3, 4
			s = Slownie1(numer) & "sta"
		Case 5 to 9
			s = Slownie1(numer) & "set"
	End Select
	Slownie100 = s
End Sub

sub Slownie999(numer) as string
	Dim ja as integer
	Dim dz as integer
	Dim se as integer
	je = numer mod 10
	dz = fix(numer/10)  mod 10
	se = fix(numer/100) mod 10
	dim s as string
	dim t as string
	dim u as string

	s = Slownie100(se)
	if dz = 1 then
		t = Slownie19(je)
		u = ""
	else
		t = Slownie10(dz)
		u = Slownie1(je)
	end if

	if s <> "" and (t<>"" or u<>"") then
		s = s & " "
	end if
	if t <> "" and u <> "" then
		t = t & " "
	end if

	Slownie999 = s & t & u
End sub

sub Slownie000(numer) as integer
	Dim je as integer
	Dim dz as integer
	je = numer mod 10
	dz = fix(numer/10)  mod 10
	if numer = 0 then
		typ = 0
	elseif numer = 1 then
		typ = 1
	elseif dz<>1 and je>=2 and je<=4 then
		typ = 2
	else
		typ = 3
	end if
	Slownie000 = typ
End Sub

Function Slownie(kwota) as string
	if kwota>=1000000000 or kwota<=-1000000000 then
		Slownie="za duża lub błędna liczba (" & cstr(kwota) & ")"
		goto koniec1
	end if
	dim s as string
	dim m as string
	dim k as long

	m=""
	if kwota < 0 then
		m = m & "minus "
		kwota = 0-kwota
	end if

	k = clng(fix(kwota))

	if k=0 then
		s = "zero"
	else
		s = Slownie999(k mod 1000)
	end if
	k = fix(k/1000)

	if k <> 0 then 
		if s<>"" and (k mod 1000)>0 then
			s = " " & s
		end if
		select case Slownie000(k mod 1000)
			case 0

			case 1
				s =                           "tysiąc"  & s
			case 2
				s = Slownie999(k mod 1000) & " tysiące" & s
			case 3
				s = Slownie999(k mod 1000) & " tysięcy" & s
		end select
	end if
	k = fix(k/1000)

	if k <> 0 then 
		if s<>"" and (k mod 1000)>0 then
			s = " " & s
		end if
		select case Slownie000(k mod 1000)
			case 0

			case 1
				s =                           "milion"  & s
			case 2
				s = Slownie999(k mod 1000) & " miliony" & s
			case 3
				s = Slownie999(k mod 1000) & " milionów" & s
		end select
	end if
	k = fix(k/1000)

	if k <> 0 then 
		s = cstr(k*1000000000) & " + " & s
	end if

	Slownie = m & s

koniec1:

End Function

function SlownieZL(kwota)
	if kwota>=1000000000 or kwota<=-1000000000 then
		SlownieZL="za duża lub błędna liczba (" & cstr(kwota) & ")"
		goto koniec2
	end if

	s=""

	zl = fix(kwota)
	gr = kwota - zl
	if gr < 0 then
		gr = 0-gr
	end if
	gr = fix((gr*100)mod 100)
	
	rem s = cstr(kwota) & " # " & cstr(zl) & " # " & cstr(gr) & " # " & s & slownie(zl)
	s = s & slownie(zl)
	select case Slownie000(zl mod 1000)
		case 1
			s = s & " złoty"
		case 2
			s = s & " złote"
		case 0,3
			s = s & " złotych"
	end select
	if true or gr <> 0 then
		s = s & " " & cstr(gr) & " gr."
	end if
	SlownieZL=s
koniec2:
end function


function Slownie100Waluta(kwota, waluta)
	if kwota>=1000000000 or kwota<=-1000000000 then
		Slownie100Waluta="za duża lub błędna liczba (" & cstr(kwota) & ")"
		goto koniec3
	end if

	s=""

	zl = fix(kwota)
	gr = kwota - zl
	if gr < 0 then
		gr = 0-gr
	end if
	gr = fix((gr*100)mod 100)
	
	rem "minus" jest dodatwany automatycznie w slownie(zl) chyba, że zl=0
	if kwota<0 and zl=0 then 
		s = s & "minus "
	end if
	
	s = s & slownie(zl)
	s = s & " " & waluta

	if true or gr <> 0 then
		s = s & " " 
		if gr<10 then
			s = s & "0"
		end if
		s = s & cstr(gr) & "/100"
	end if
	Slownie100Waluta=s
koniec3:
end function

rem vim:ts=4:ft=vb


Function NumToWords( ByVal nNumber As Double, nCurrency) As String
   cWords = ""
   
   If nNumber < 0 Then
      cWords = "Negative " + NumToWords( -1 * nNumber, nCurrency )
   
   ElseIf nNumber <> Int( nNumber ) Then
      cWords = NumToWords( Int( nNumber ), "" )
      cWords = cWords + " "
      nFrac = nNumber - Int( nNumber )
      
      nFrac = fix((nFrac*100)mod 100)
      
      s = s & " " 
	  if nFrac < 10 then
	     s = s & "0"
      end if

      s = s & cstr(nFrac) & "/100"
      
      cWords = cWords + " " + nCurrency + s
   
   ElseIf nNumber < 20 Then
      Select Case nNumber
         Case 0: cWords = "zero"
         Case 1: cWords = "one"
         Case 2: cWords = "two"
         Case 3: cWords = "three"
         Case 4: cWords = "four"
         Case 5: cWords = "five"
         Case 6: cWords = "six"
         Case 7: cWords = "seven"
         Case 8: cWords = "eight"
         Case 9: cWords = "nine"
         Case 10: cWords = "ten"
         Case 11: cWords = "eleven"
         Case 12: cWords = "twelve"
         Case 13: cWords = "thirteen"
         Case 14: cWords = "fourteen"
         Case 15: cWords = "fifteen"
         Case 16: cWords = "sixteen"
         Case 17: cWords = "seventeen"
         Case 18: cWords = "eighteen"
         Case 19: cWords = "ninteen"
      End Select
      
      If nCurrency <> "" Then
         cWords = cWords + " " + nCurrency + " 0/100"
      End If
   
   ElseIf nNumber < 100 Then
      nTensPlace = Int( nNumber / 10 )
      nOnesPlace = nNumber Mod 10
      Select Case nTensPlace * 10
         Case 20: cWords = "twenty"
         Case 30: cWords = "thirty"
         Case 40: cWords = "forty"
         Case 50: cWords = "fifty"
         Case 60: cWords = "sixty"
         Case 70: cWords = "seventy"
         Case 80: cWords = "eighty"
         Case 90: cWords = "ninty"
      End Select
      If nOnesPlace > 0 Then
         cWords = cWords + " " + NumToWords( nOnesPlace, "" )
      EndIf
      
      If nCurrency <> "" Then
         cWords = cWords + " " + nCurrency + " 0/100"
      End If
   
   ElseIf nNumber < 1000 Then
      nHundredsPlace = Int( nNumber / 100 )
      nRest = nNumber Mod 100
      cWords = NumToWords( nHundredsPlace, "" )
      cWords = cWords + " hundred"
      If nRest > 0 Then
         cWords = cWords + " " + NumToWords( nRest, "" )
      EndIf
      
      If nCurrency <> "" Then
         cWords = cWords + " " + nCurrency + " 0/100"
      End If
   
   ElseIf nNumber < 1000000 Then
      nThousands = Int( nNumber / 1000 )
      nRest = nNumber Mod 1000
      cWords = NumToWords( nThousands, "" )
      cWords = cWords + " thousand"
      If nRest > 0 Then
         cWords = cWords + " " + NumToWords( nRest, "" )
      EndIf

      If nCurrency <> "" Then
         cWords = cWords + " " + nCurrency + " 0/100"
      End If
   EndIf
   
   NumToWords() = cWords
End Function

rem vim:ts=4:ft=vb
