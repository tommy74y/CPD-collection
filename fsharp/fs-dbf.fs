module programm
open System
open System.Threading
open System.Diagnostics 
open Utils
open Utils.Tasks

let main argv = 
  printfn "Run... "
  Tasks.code02 |> printfn "Tasks.code02=%i"
  Thread.Sleep 10
  Tasks.code01 |> printfn "Tasks.code05=%i"
  printfn "End... "
  System.Console.ReadKey() |> ignore
 

[<EntryPoint>]
//let EntryPoint (argv : string[]) = 
let EntryPoint argv = 
  main argv  
  0