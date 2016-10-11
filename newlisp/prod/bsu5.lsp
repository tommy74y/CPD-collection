;;; goal - parsing dbf files
;;; 30.05.2014 Tomilov
;;;     doing command line arg
;;; 15.05.2014 Tomilov
;;;     walking on list of dbf fields
;;; +29.05.2014 Tomilov
;;;     convert file
							;;initializing
(set 'in_dbf_file (main-args 2))				;;(println in_dbf_file)
(set 'out_txt_UTF-8 (replace "dbf" (main-args 2) "txt"))	;;(println out_txt_UTF-8)
(set 'out_txt_CP1251 (replace ".dbf" (main-args 2) "-.txt"))	;;(println out_txt_CP1251)


(set 'dbf_fields '())
(set 'dbf_f_index 0)

;;(set 'fdbf (open dbf_file_name "read"))
(set 'fdbf (open in_dbf_file "read"))
							;;check if file opened
(if (nil? fdbf) (
	(print "cant open file") 
	(exit -1)))
(read fdbf buff 32) 					;;read/skip header of dbf struct	
							;;read field struct
(set 'dbf_f_length 1)
(read fdbf buff1 1)
(do-until (= buff1 "\013")
	(read fdbf buff31 31)
	(set 'buff (append buff1 buff31))		
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
                                                        ;;and save to file
(write-file out_txt_UTF-8 "1\t2\t3\t4\t5\t6\t7\t8\t9\t10\n")
(do-while (= dbf_f_length (read fdbf buff dbf_f_length))
(if (= (slice buff 0 1) "\032") (begin                  ;;skip deleted record
							;;(println "KNDADR_1 --  1" 
(append-file out_txt_UTF-8 (trim (string (slice buff 1976 40)) " ")) (append-file out_txt_UTF-8 " ")
							;;(println "KNDADR_2 --  1" 
                                                        ;;(println (trim (string (slice buff 1530 40)) " "))
(append-file out_txt_UTF-8 (trim (string (slice buff 2016 40)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "AUTOKZ   --  2" 
(append-file out_txt_UTF-8 (trim (string (slice buff 1542 15)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "FAHRNAME --  3" 
(append-file out_txt_UTF-8 (trim (string (slice buff 1561 30)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "REZBEZ   --  4" 
(append-file out_txt_UTF-8 (trim (string (slice buff 1228 60)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "ABRMEN   --  5"
(append-file out_txt_UTF-8 (replace "." (trim (string (slice buff 1514 10)) " ") ",")) (append-file out_txt_UTF-8 "\t")
							;;(println "REZNR    --  6" 
;;(append-file out_txt_UTF-8 (replace "." (trim (string (slice buff 1216 12)) " ") ",")) (append-file out_txt_UTF-8 "\t")
(append-file out_txt_UTF-8 (trim (string (slice buff  1216 12)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "KONSBER  --  7" 
(append-file out_txt_UTF-8 (trim (string (slice buff  1368 16)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "LIEFNR   --  8"
(append-file out_txt_UTF-8 (trim (string (slice buff  429  8)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "PRODDAT  --  9"
(append-file out_txt_UTF-8 (trim (string 
	(slice buff  389  4) "-"
	(slice buff  393  2) "-"
	(slice buff  395  2)                             ) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "PRODZT   -- 10" 
(append-file out_txt_UTF-8 (trim (string (slice buff  397  8)) " "))(append-file out_txt_UTF-8 "\t")
							;;(println "NAMEHERST   -- 11" 
(append-file out_txt_UTF-8 (trim (string (slice buff  1052  30)) " "))(append-file out_txt_UTF-8 "\n")
))
)
                                                        ;;convert file
(exec (append "iconv.exe -f UTF-8 -t CP1251 " out_txt_UTF-8 " > " out_txt_CP1251 ))
							;;clearing and exiting
(close fdbf)
(exit 0)