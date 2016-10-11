;;; prj - parce dbf files
;;; 15.05.2014 Tomilov
;;;    walking on list of dbf fields
							;;initializing
(set 'dbf_file_name "dbf")
(set 'dbf_fields '())
(set 'dbf_f_index 0)

(set 'fdbf (open dbf_file_name "read"))
							;;check if file opened
(if (nil? fdbf) (
	(print "cant open file") 
	(exit -1)))
(read fdbf buff 32) 					;;read/skip header of dbf struct	
							;;read field by field struct
(set 'dbf_f_length 1)
(read fdbf buff1 1)
(do-until (= buff1 "\013")
	(read fdbf buff31 31)
	(set 'buff (append buff1 buff31))		;;(println buff1 " -- " (string buff31) " -- " (string buff))
	(set 'dbf_fields 
		(append dbf_fields 
			(list 
				(list 
					dbf_f_index 
					(string (slice buff 0 10))
					(char (buff 16))                         
					(char (buff 17))
					dbf_f_length
				)
			)
		)
	)
	(set 'dbf_f_length (+ dbf_f_length (char (buff 16))))
	(inc dbf_f_index)
	(read fdbf buff1 1)
)
							;;calculate record lenght
(set 'dbf_f_length 1)
(dolist (x dbf_fields) (set 'dbf_f_length (+ dbf_f_length (x 2))))
							;;read all data rows
;;KNDADR_2	1531	40
;;AUTOKZ	1056	15
;;FAHRNAME	1075	30
;;REZBEZ	790	60
;;ABRMEN	1028	10
;;REZNR		778	12
;;KONSBER	882	16
;;LIEFNR	311	8
;;PRODDAT	279	8
;;PRODZT	287     8



(do-while (= dbf_f_length (read fdbf buff dbf_f_length))
(if (= (slice buff 0 1) "\032") (begin
;(append-file "out.txt" ;;(println "FLAGDELETERECORD -- " 
;	(trim (string (slice buff 0 1))) " ")(append-file "out.txt" "\n")
(append-file "out.txt" ;;(println "KNDADR_2 -- " 
	(trim (string (slice buff 1530 40))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "AUTOKZ   -- " 
	(trim (string (slice buff 1056 15))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "FAHRNAME -- " 
	(trim (string (slice buff 1075 30))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "REZBEZ   -- " 
	(trim (string (slice buff  790 60))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "ABRMEN   -- " 
	(trim (string (slice buff 1028 10))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "REZNR    -- " 
	(trim (string (slice buff  778 12))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "KONSBER  -- " 
	(trim (string (slice buff  882 16))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "LIEFNR   -- " 
	(trim (string (slice buff  311  8))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "PRODDAT  -- " 
	(trim (string (slice buff  279  8))) " ")(append-file "out.txt" "\t")
(append-file "out.txt" ;;(println "PRODZT   -- " 
	(trim (string (slice buff  287  8))) " ")(append-file "out.txt" "\n")
))
)
(exec "iconv.exe -f UTF-8 -t CP1251 out.txt > out-1251.txt")
(save "dfb-rec.txt" 'buff)          
;;(read fdbf buff dbf_f_length)
;;(println buff)
;;(read fdbf buff dbf_f_length)
;;(println buff)

(save "dfb-stru.txt" 'dbf_fields)          
							;;clearing and exiting
(close fdbf)
(exit 0)