
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/compositeIngredient.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/ingredient.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/quantity.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/simpleIngredient.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/unit.dart';
import 'package:ricettario/studionotturno/cookbook/domain/ingredient/unitRegister.dart';
import 'package:ricettario/studionotturno/cookbook/domain/recipe/cookbook.dart';
import 'package:ricettario/studionotturno/cookbook/domain/recipe/recipe.dart';
import 'package:ricettario/studionotturno/cookbook/ui/pages/recipePage.dart';
import 'package:ricettario/studionotturno/cookbook/ui/pages/simpleIngredientPage.dart';


class CompositeIngredientPage extends StatefulWidget{

  CompositeIngredient comp;
  String recipe;

  CompositeIngredientPage(String recipe,CompositeIngredient comp){
    this.comp=comp;
    this.recipe=recipe;
  }

  @override
  State<StatefulWidget> createState() => CompositeIngredientState(this.recipe,this.comp);

}

class CompositeIngredientState extends State<CompositeIngredientPage>{

  CompositeIngredient compositeIngredient;
  String recipe;
  UnitRegister unitRegister;

  CompositeIngredientState(String recipe,CompositeIngredient ingredient){
    this.unitRegister=new UnitRegister();
    if(ingredient==null) this.compositeIngredient=new CompositeIngredient("", new Quantity().setAmout(0).setUnit(this.unitRegister.getUnit("gr")));
      else this.compositeIngredient=ingredient;
      this.recipe=recipe;
  }


  final _formKey = GlobalKey<FormState>();//per la validazione della form
  var _name,_quantity,_dropdownValue;
  //controllers per i componeneti grafici
  static TextEditingController ingredientName,ingredientQuantity;


  @override
  Widget build(BuildContext context) {

    //dropdownValue=unitRegister.getUnits().elementAt(0).getAcronym();
    //#region Controllers

    ingredientName= new TextEditingController(
        text: this.compositeIngredient.getName()
    );

    ingredientQuantity= new TextEditingController(
        text: this.compositeIngredient.getAmount().getAmount().toString()
    );

    //#endregion Controllers

    return Scaffold(
      appBar: AppBar(
        title: Text((this.compositeIngredient.getName()==null || this.compositeIngredient.getName()=="")?'New ingredient':this.compositeIngredient.getName().toUpperCase(),style:TextStyle(fontSize: 20)),
        iconTheme: IconThemeData(color: Colors.purple),
        leading: Icon(Icons.kitchen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                key: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 22,color: Colors.purple,fontWeight: FontWeight.bold,letterSpacing: 1.2),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter the name';
                  this._name=value;
                  return null;
                },
                onChanged: (value){
                  this.compositeIngredient.setName(value);
                },
                controller:ingredientName,
              ),
              TextFormField(
                key: _quantity,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(fontSize: 22,color: Colors.purple,fontWeight: FontWeight.bold,letterSpacing: 1.2),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter the name';
                  this._quantity=value;
                  return null;
                },
                onChanged: (value){
                  this.compositeIngredient.getAmount().setAmout(double.parse(value));
                },
                controller:ingredientQuantity,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                //height: 200.0,
                child: Row(
                  children: <Widget>[
                    Text("Unit   ",style: TextStyle(fontSize: 22,color: Colors.purple,fontWeight: FontWeight.bold,letterSpacing: 1.2),),
                    getListOfUnit(context)
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Ingredients",style: TextStyle(fontSize: 20,color: Colors.purple,fontWeight: FontWeight.bold,letterSpacing: 1.2)),
                  ),
                  _simpleIngredients(context),//Lista ingredienti
                ],
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: ButtonTheme(
                  height: 50,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: (){
                        saveIngredient();
                    },
                    color: Colors.blueGrey[900],
                    highlightColor: Colors.lightGreenAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Save Ingredient',style: TextStyle(fontSize: 20,color: Colors.purple,fontWeight: FontWeight.bold,letterSpacing: 1.2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleIngredientPage(this.recipe,this.compositeIngredient,null)),
          ),
        },
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.purple,
      ),
    );
  }

  void saveIngredient(){

    Recipe r=Cookbook().getRecipe(this.recipe);
    if(r.containsByName(this.compositeIngredient.getName())){
      //ingrediente già presente->modificarlo
    }
    else{
      //ingrediente non presente->salvarlo
      r.add(this.compositeIngredient);
    }


    Navigator.pushReplacement (
        context,
        MaterialPageRoute(builder: (_) => RecipePage(r)));

  }

  Widget getListOfUnit(BuildContext context) {

    return DropdownButton<String>(
      hint: this.compositeIngredient.getAmount().getUnit().getAcronym()!=null?Text(this.compositeIngredient.getAmount().getUnit().getAcronym()):Text("Unit"),
      isDense: true,
      value: _dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 40,
      elevation: 16,
      style: TextStyle(color: Colors.blueGrey[900],fontSize: 26),
      underline: Container(
        height: 2,
        color: Colors.purple,
      ),
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
          String ac=_dropdownValue.toString();
          this.compositeIngredient.setAmount(new Quantity().setAmout(this.compositeIngredient.getAmount().getAmount()).setUnit(unitRegister.getUnit(ac)));

        });
      },
      items: unitRegister.getUnits()
          .map<DropdownMenuItem<String>>((Unit value) {
        return DropdownMenuItem<String>(
          value: value.acronym,
          child: Text(value.acronym,style: TextStyle(fontSize: 26),),
        );
      }).toList(),
    );
  }

  Widget _simpleIngredients(BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (SimpleIngredient simple in this.compositeIngredient.getIngredients()) {
      list.add(new ListTile(
        title: Text(simple.getName().toUpperCase(), style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontStyle: FontStyle.italic)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SimpleIngredientPage(
                        this.recipe, this.compositeIngredient, simple)),
          );
          //TODO go to specific RecipePage
        },
        leading: const Icon(Icons.plus_one, size: 40.0, color: Colors.blueGrey),
        subtitle: Text(simple.getAmount().toString()),
      ));
    }
    return new ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: ListTile.divideTiles(
            context: context,
            color: Colors.blueGrey,
            tiles: list
        ).toList()
    );
  }

}