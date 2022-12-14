import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];

 Future<File> _getFile () async{

   final diretorio = await getApplicationDocumentsDirectory();
   return File( "${diretorio.path}/dados.json" );

 }

  _salvarArquivo() async {

   var arquivo = await _getFile();


    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Ir ao mercado";
    tarefa["Realizada"] = false;
    _listaTarefas.add(tarefa);

    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo()async{
   try{
     final arquivo = await _getFile();
     return arquivo.readAsString();
   }
   catch(e){
     return null;
   }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

   //_salvarArquivo();
    print("itens: " + _listaTarefas.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(itemBuilder: (context, index){
        return ListTile(
          title:Text( _listaTarefas[index]["titulo"]),
        );
      },
      itemCount: _listaTarefas.length,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text('Adicionar Tarefa'),
              content: TextField(
                decoration: InputDecoration(
                  hintText: 'Digite a terefa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide(
                      color: Colors.purple
                    ),
                  ),
                ),
                onChanged: (text){

                },
              ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancelar')),
               TextButton(onPressed: (){
                 Navigator.pop(context);
               }, child: Text('Salvar'))
              ],

            );
          });
        },
        backgroundColor: Colors.purple,
          elevation: 6,
      ),

    );
  }
}
