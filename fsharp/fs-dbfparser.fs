namespace DbfParser
open System
open System.Diagnostics 
open Utils.BinParserModule

module DbfParser =
  let pBuilder  = new BinParserBuilder()
  let DbfParser = pBuilder {
    //dbf header
    let! _signature             = RByte  //    0 byte
    let! _year                  = RByte  //    1 byte
    let! _month                 = RByte  //    2 byte
    let! _day                   = RByte  //    3 byte
    let! _numberOfRecords       = RInt   //  4-7 int
    let! _headerLength          = RShort //  8-9 short
    let! _recordLength          = RShort //10-11 short
    let! _reserv1               = RShort //12-13 short
    let! _incompleteTransaction = RByte  //   14 byte
    let! _encryptionFlag        = RByte  //   15 byte
    let! _freeRecordThread      = RInt   //16-19 int
    let! _reserv2               = RInt   //20-23 int
    let! _reserv3               = RInt   //24-27 int
    let! _mdxFlag               = RByte  //   28 byte
    let! _languageDriver        = RByte  //   29 byte
    let! reserv4                = RShort //30-31 short
    //dbf header terminator
    //dbf fields
    //dbf data
    return (_signature)
    }
