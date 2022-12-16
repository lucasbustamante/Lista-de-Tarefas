# lista_de_terefas
## Anotações de estudo

### Floating Action Button

Algumas dicas de como usar o Floating Action Button
Ex:

Pag. 9
```dart
floatingActionButton: FloatingActionButton(
        
        foregroundColor: Colors.purple //Cor do Child
          elevation: 6, //define sobra
      )
      
```

Podemos usar o floatingActionButtonLocation para definir local de onde o widget ficará, e usando ".docked",
podemos "mesclar" com o ButtonNavigationBar
ex:
```dart
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){}
      ),
bottomNavigationBar: BottomAppBar(child: IconButton(
  onPressed: (){},
  icon: Icon(Icons.add),
),
  shape: CircularNotchedRectangle(),
),
```

Assim a Bar recebe um espaço para o FloatingActionButton

A função .extended cria um FloatingActionButton maior, onde podemos adicionar icon e um label
ex:
```dart
floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('add'), // sendo que o label é obrigatorio
```

Pag. 10

### Salvando dados utilizando arquivo

Primeiramente importe a biblioteca [Path Provider](https://pub.dev/packages/path_provider), com isso crie um metodo.

```dart
_salvarArquivo() async {

   var arquivo = await _getFile();

    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }
```

(Para diminuir nosso código, podemos criar um metodo _getFile)
Ex:
```dart
Future<File> _getFile () async{

   final diretorio = await getApplicationDocumentsDirectory();
   return File( "${diretorio.path}/dados.json" );

 }
 ```

### Metodo para ler arquivo salvo

 ```dart
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
  ```

```dart
_salvarTArefa(){
String textoDigitado = _controllerTarefa.text;

Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Ir ao mercado";
    tarefa["Realizada"] = false;
    setState((){
_listaTarefas.add(tarefa);
});
_salvarArquivo();
}
```

#### ListView Dicas

Pag. 12

Dentro do ListView.builder podemos adicionar CheckBoxListTile

Podemos usar também o Dismissible
Ex:

```dart
ListView.builder(
itemCount: _listaTarefas.length,
itemBuilder: (context, index){
final item = _lista[index];

return Dismissible(
key: Key(item),
child: ListTile(
title: Text(item);
direction: // direções para onde arrastar o widget,
backgound: // aqui podemos definir um widget, exemplo, um container vermelho,
//assim ele pode ser o fujndo do widget quando arrastado para o lado
}
)
```
Podemos definir um segundo background usando: SecondaryBackgound
Ex:

```dart
backgound: Container(
color: Colors.green,
padding: EdgeInsets.all(16),
child: Row(mainAxisAlignment: MainAxisAlignment.start,
children: [
  Icon(
Icons.edit, 
color: Colors.white,
)
]
)
),
secondaryBackgound: Container(
color: Colors.red,
padding: EdgeInsets.all(16),
child: Row(mainAxisAlignment: MainAxisAlignment.end,
children: [
Icon(
Icons.delete,
color: Colors.white,
)
]
)
)
```
Pag. 13
E para saber qual deslizamento está sendo feito usamos.
Ex:
```dart
onDismissed: (direction){
  if(diretion == DismissiDiretion.endToStart){
    
}else if(diretion == DismissiDiretion.startToEnd){
    setState(({
  _lista.removeAT(index)
}))
}
}
```

E ainda podemos compactar o código criando um metodo
Ex: 
```dart
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
```