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
  TextEditingController _controllerTarefa = TextEditingController();

 Future<File> _getFile () async{

   final diretorio = await getApplicationDocumentsDirectory();
   return File( "${diretorio.path}/dados.json" );

 }

  _salvarArquivo() async {

   var arquivo = await _getFile();

    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _salvarTarefa(){

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = _controllerTarefa.text;
    tarefa["realizada"] = false;
    _salvarArquivo();
    setState(() {
      _listaTarefas.add(tarefa);
    });
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

  Widget criarItemLista(context, index){
   final item = _listaTarefas[index]['titulo'];
   return Dismissible(
     onDismissed: (direction){
         _listaTarefas.removeAt(index);
       _salvarArquivo();
     },
     direction: DismissDirection.endToStart,
       background: Container(
         padding: EdgeInsets.all(16),
         child: Row(mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Icon(Icons.delete, color: Colors.white,)
           ],
         ),
         color: Colors.red,
       ),
       key: Key(item),
       child: ListTile(
         title: CheckboxListTile(
           onChanged: (valorAlterado){
             setState(() {
               _listaTarefas[index]["realizada"] = valorAlterado;
             });
             _salvarArquivo();
           },
           value: _listaTarefas[index]["realizada"],
           title:Text( _listaTarefas[index]["titulo"]),
         ),
       ));
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemBuilder: criarItemLista,
      itemCount: _listaTarefas.length,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text('Adicionar Tarefa'),
              content: TextField(
                controller: _controllerTarefa,
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
                  _controllerTarefa.clear();
                }, child: Text('Cancelar')),
               TextButton(onPressed: (){
                 _salvarTarefa();
                 Navigator.pop(context);
                 _controllerTarefa.clear();
               }, child: Text('Salvar')),
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
