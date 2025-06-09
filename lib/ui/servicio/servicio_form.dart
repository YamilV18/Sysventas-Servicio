
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sysventas/apis/servicio_api.dart';
import 'package:sysventas/apis/tipo_servicio_api.dart';
import 'package:sysventas/modelo/ServicioModelo.dart';
import 'package:sysventas/modelo/TipoServicioModelo.dart';
import 'package:sysventas/util/TokenUtil.dart';

class ServicioForm extends StatefulWidget {
  const ServicioForm({super.key});

  @override
  State<ServicioForm> createState() => _ServicioFormState();
}

class _ServicioFormState extends State<ServicioForm> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioBaseController = TextEditingController();
  final estadoController = TextEditingController();
  //final stockController = TextEditingController();
  //final stockOldController = TextEditingController();
/*
  Categoria? selectedCategoria;
  Marca? selectedMarca;
  UnidadMedida? selectedUnidad;
  */
  TipoServicio? selectedTipo;
/*
  late List<Categoria> categorias = [];
  late List<Marca> marcas = [];
  late List<UnidadMedida> unidades = [];
  */
  late List<TipoServicio> tipos = [];

  @override
  void initState(){
    super.initState();
    _loanData();
  }

  void _loanData() async {
    try {
      /*
      final apim = Provider.of<MarcaApi>(context, listen: false);
      final resultM = await apim.getMarca(TokenUtil.TOKEN);

      final apic = Provider.of<CategoriaApi>(context, listen: false);
      final resultC = await apic.getCategoria(TokenUtil.TOKEN);

      final apiu = Provider.of<UnidadmedidaApi>(context, listen: false);
      final resultU = await apiu.getUnidadMedida(TokenUtil.TOKEN);
      */

      final apit = Provider.of<TipoServicioApi>(context, listen: false);
      final resultT = await apit.getTipo(TokenUtil.TOKEN);
      setState(() {
        /*
        marcas = resultM;
        categorias=resultC;
        unidades=resultU;
        */
        tipos=resultT;
      });

    } catch (e) {
      print('Error al cargar los tipos de servicio: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: descripcionController,
                //keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: precioBaseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio Base'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              /*
              DropdownButtonFormField<Categoria>(
                value: selectedCategoria,
                items: categorias.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat.nombre));
                }).toList(),
                onChanged: (value) => setState(() => selectedCategoria = value),
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) => value == null ? 'Seleccione una categoría' : null,
              ),
              DropdownButtonFormField<Marca>(
                value: selectedMarca,
                items: marcas.map((mar) {
                  return DropdownMenuItem(value: mar, child: Text(mar.nombre));
                }).toList(),
                onChanged: (value) => setState(() => selectedMarca = value),
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) => value == null ? 'Seleccione una marca' : null,
              ),
              DropdownButtonFormField<UnidadMedida>(
                value: selectedUnidad,
                items: unidades.map((um) {
                  return DropdownMenuItem(value: um, child: Text(um.nombreMedida));
                }).toList(),
                onChanged: (value) => setState(() => selectedUnidad = value),
                decoration: const InputDecoration(labelText: 'Unidad de Medida'),
                validator: (value) => value == null ? 'Seleccione una unidad' : null,
              ),

               */
              DropdownButtonFormField<TipoServicio>(
                value: selectedTipo,
                items: tipos.map((tip) {
                  return DropdownMenuItem(value: tip, child: Text(tip.nombre));
                }).toList(),
                onChanged: (value) => setState(() => selectedTipo = value),
                decoration: const InputDecoration(labelText: 'Tipo de servicio'),
                validator: (value) => value == null ? 'Seleccione un tipo' : null,
              ),
              const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context, true);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _registrarServicio,
                  child: const Text('Guardar'),
                )
              ],
            )
            ],
          ),
        ),
      ),
    );
  }

  void _registrarServicio() async{
    if (_formKey.currentState!.validate()) {
      final servicio = ServicioCreateDto(
        //idServicio: 0, // o generado por backend
        nombreServicio: nombreController.text,
        descripcion: descripcionController.text,
        precioBase: double.tryParse(precioBaseController.text) ?? 0,
        estado: estadoController.text,
        tipo: selectedTipo!.idTipo,

        /*stockOld: double.tryParse(stockOldController.text) ?? 0,
        categoria: selectedCategoria!.idCategoria,
        marca: selectedMarca!.idMarca,
        unidadMedida: selectedUnidad!.idUnidad,*/
      );
      var api = await Provider.of<ServicioApi>( context, listen: false)
          .crearServicio(TokenUtil.TOKEN,servicio);

      if (api.toJson()!=null) {
        Navigator.pop(context, () {setState(() {}); });
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
      }
      print(servicio.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio registrado exitosamente')),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No estan bien los datos de los campos!')),
      );
    }
  }
}