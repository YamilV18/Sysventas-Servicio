import 'dart:io';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:sysventas/apis/servicio_api.dart';
import 'package:sysventas/apis/tipo_servicio_api.dart';

import 'package:sysventas/comp/TabItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sysventas/modelo/ServicioModelo.dart';
import 'package:sysventas/theme/AppTheme.dart';
import 'package:sysventas/ui/servicio/servicio_edit.dart';
import 'package:sysventas/ui/servicio/servicio_form.dart';
import 'package:sysventas/util/TokenUtil.dart';
import '../help_screen.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class MainServicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServicioApi>(create: (_) => ServicioApi.create(),),
        /*
        Provider<MarcaApi>(create: (_) => MarcaApi.create()),
        Provider<CategoriaApi>(create: (_) => CategoriaApi.create()),
        Provider<UnidadmedidaApi>(create: (_) => UnidadmedidaApi.create()),

        // Provider<AsistenciaxApi>(create: (_) => AsistenciaxApi.create(),),
         */
        Provider<TipoServicioApi>(create: (_) => TipoServicioApi.create(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: ServicioUI(),
      ),
    );
  }
}

class ServicioUI extends StatefulWidget {
  @override
  _ServicioUIState createState() => _ServicioUIState();
}

class _ServicioUIState extends State<ServicioUI> {
  late ServicioApi apiService;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var api;
  late List<ServicioResp> personaL;
  late List<ServicioResp> personaXB = [];

  @override
  void initState() {
    super.initState();
    _loanData();
  }

  _loanData() async {
    setState(() {
      _isLoading = true;
      apiService = ServicioApi.create();
      personaXB.clear();
      Provider.of<ServicioApi>(context, listen: false)
          .getServicio(TokenUtil.TOKEN)
          .then((data) {
        personaXB = List.from(data);
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      personaL = List.from(personaXB);
      _isLoading = false;
    });
    print("entro aqui");
  }

  final GlobalKey<AnimatedFloatingActionButtonState> key = GlobalKey<AnimatedFloatingActionButtonState>();

  String text = 'Asistencia';
  String subject = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];
  bool _isLoading = false;

  Future onGoBack(dynamic value) async {
    setState(() {
      _loanData();
      print(value);
    });
  }

  final _controller = TextEditingController();
  //* update function
  void updateList(String value) {

    setState(() {
      personaL = personaXB
          .where(
            (element){
              return element.nombreServicio!.toLowerCase().contains(value.toLowerCase(), ) ||
                  element.descripcion!.toLowerCase().contains(value.toLowerCase());
            },
          ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: AppTheme.themeDataLight,
      darkTheme: AppTheme.themeDataDark,
      home: Scaffold(
        appBar: new AppBar(
          title: Text(
            'Lista de Servicios',
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print("Si funciona");
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print("Si funciona 2");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServicioForm()),
                  ).then(onGoBack);
                },
                child: Icon(Icons.add_box_sharp),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.nearlyWhite,


        body: _isLoading?Center(child: CircularProgressIndicator(),)
            :_buildListView(context),

        bottomNavigationBar: _buildBottomTab(),
        floatingActionButton: AnimatedFloatingActionButton(
          key: key,
          fabButtons: <Widget>[
            add(),
            image(),
            inbox(),
          ],
          colorStartAnimation: AppTheme.themeData.colorScheme.inversePrimary,
          colorEndAnimation: Colors.red,
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context/*, List<ActividadModelo> persona*/) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 8.0),
                child: TextFormField(
                  onChanged: (value) => updateList(value),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Buscar Servicios...",
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear_sharp,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _controller.clear();
                          updateList(_controller.value.text);
                        }),
                    //fillColor: const Color.fromARGB(95, 119, 68, 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: ListView.builder(
                        itemCount: personaL.length,
                        itemBuilder: (context, index) {
                          ServicioResp personax = personaL[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                        title: Row(
                                          children: [
                                            Container(
                                              child: Text(personax.nombreServicio!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            )
                                          ],
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppTheme.themeData.colorScheme.primaryContainer,
                                                ),
                                                child: Text(
                                                  personax.descripcion!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8), // Espacio entre los elementos
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: AppTheme.themeData.colorScheme.primaryContainer,
                                                ),
                                                child: Text(
                                                  'S/. ${personax.precioBase}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),


                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/imagen/man-icon.png"),
                                        ),
                                        trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: IconButton(
                                                            icon: Icon(Icons.edit),
                                                            iconSize: 24,
                                                            padding:
                                                            EdgeInsets.zero,
                                                            constraints:
                                                            BoxConstraints(),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ServicioFormEdit(
                                                                            modelA:personax)
                                                                ),
                                                              ).then(onGoBack);
                                                            })),
                                                    Expanded(
                                                        child: IconButton(
                                                            icon:
                                                            Icon(Icons.delete),
                                                            iconSize: 24,
                                                            padding:
                                                            EdgeInsets.zero,
                                                            constraints:
                                                            BoxConstraints(),
                                                            //color: AppTheme.themeData.colorScheme.inversePrimary,
                                                            onPressed: () {
                                                              showDialog(
                                                                  context: context,
                                                                  barrierDismissible:
                                                                  true,
                                                                  builder:
                                                                      (BuildContext
                                                                  context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Mensaje de confirmacion"),
                                                                      content: Text(
                                                                          "Desea Eliminar?"),
                                                                      actions: [
                                                                        FloatingActionButton(
                                                                          child: const Text(
                                                                              'NO'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context)
                                                                                .pop('Failure');
                                                                          },
                                                                        ),
                                                                        FloatingActionButton(
                                                                            child: const Text(
                                                                                'SI'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context)
                                                                                  .pop('Success');
                                                                            })
                                                                      ],
                                                                    );
                                                                  }).then((value) {
                                                                if (value
                                                                    .toString() ==
                                                                    "Success") {
                                                                  print(
                                                                      personax.idServicio);
                                                                  Provider.of<ServicioApi>(
                                                                      context,
                                                                      listen:
                                                                      false)
                                                                      .deleteServicio(
                                                                      TokenUtil
                                                                          .TOKEN,
                                                                      personax.idServicio)
                                                                      .then((value) =>_loanData()
                                                                  );
                                                                  //var onGoBack = onGoBack;
                                                                  //BlocProvider.of<ServiciosBloc>(context).add(DeleteServicioEvent(servicio: state.serviciosList[index]));
                                                                }
                                                              });
                                                            }))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: IconButton(
                                                        icon: Icon(Icons.qr_code),
                                                        padding: EdgeInsets.zero,
                                                        constraints:
                                                        BoxConstraints(),
                                                        onPressed: () {
                                                          /*Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyAppQR(
                                                                      modelA:
                                                                          personax,
                                                                    )),
                                                      ).then(onGoBack);*/
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(child: Builder(
                                                      builder:
                                                          (BuildContext context) {
                                                        return IconButton(
                                                          icon: Icon(Icons
                                                              .send_and_archive_sharp),
                                                          padding: EdgeInsets.zero,
                                                          constraints:
                                                          BoxConstraints(),
                                                          onPressed: () async {
                                                            //          List<AsistenciaxRespModelo> api=await Provider.of<AsistenciaxApi>(context, listen: false).getAsistenciapa(TokenUtil.TOKEN);
                                                            //exportAsistenciaToExcel(api);
                                                            await Future.delayed(const Duration(seconds: 1));
                                                            print("OJO:${imagePaths.isEmpty}");
                                                            text="Exportando Asistencias";
                                                            if(!text.isEmpty && !imagePaths.isEmpty){
                                                              _onShare(context);
                                                              Fluttertoast.showToast(
                                                                  msg: "Exporto correctamente",
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.blue,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            }else{
                                                              Fluttertoast.showToast(
                                                                  msg: "Error Al compartir",
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.blue,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                                    ))
                                                  ],
                                                ),
                                              )
                                            ])),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ])),
      ],
    );
  }

  int selectedPosition = 0;
  final tabs = ['Home', 'Profile', 'Help', 'Settings'];

  _buildBottomTab() {
    return BottomAppBar(
      //color: AppTheme.themeData.colorScheme.primaryContainer,

      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TabItem(
            icon: Icons.menu,
            text: tabs[0],
            isSelected: selectedPosition == 0,
            onTap: () {
              setState(() {
                selectedPosition = 0;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpScreen();
              }));
            },
          ),
          TabItem(
            icon: Icons.person,
            text: tabs[1],
            isSelected: selectedPosition == 1,
            onTap: () {
              setState(() {
                selectedPosition = 1;
              });
            },
          ),
          TabItem(
            text: tabs[2],
            icon: Icons.help,
            isSelected: selectedPosition == 2,
            onTap: () {
              setState(() {
                selectedPosition = 2;
              });
            },
          ),
          TabItem(
            text: tabs[3],
            icon: Icons.settings,
            isSelected: selectedPosition == 3,
            onTap: () {
              setState(() {
                selectedPosition = 3;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          key.currentState?.closeFABs();
        },
        heroTag: Text("Image"),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: Text("Image"),
        tooltip: 'Image',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: Text("Inbox"),
        tooltip: 'Inbox',
        child: Icon(Icons.inbox),
      ),
    );
  }

  /*void exportAsistenciaToExcel(List<AsistenciaxRespModelo> asistencia) {
    // Crear un nuevo archivo Excel
    var excel = Excel.createExcel();
    // Crear una nueva hoja en el archivo Excel
    Sheet sheetObject = excel['Asistencia'];
    // Escribir los encabezados de columna en la primera fila
    List<String> headers = ['Código', 'Fecha', 'Activiad','Hora'];
    for (var col = 0; col < headers.length; col++) {
      CellIndex cellIndex =
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0);
      sheetObject.cell(cellIndex).value = headers[col];
    }

    // Escribir los datos de asistencia en las filas siguientes
    for (var row = 0; row < asistencia.length; row++) {
      AsistenciaxRespModelo asistenciax = asistencia[row];
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
          .value = asistenciax.cui;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
          .value = asistenciax.fecha;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
          .value = asistenciax.actividadId.nombreActividad;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row + 1))
          .value = asistenciax.horaReg;
    }

    // Guardar el archivo Excel en el sistema de archivos
    saveExcel(excel, 'asistencia.xlsx');
  }*/

  Future<void> saveExcel(Excel excel, String fileName) async {
    try {
      var bytes = excel.encode();
      var dir = await getExternalStorageDirectory();

      if (dir != null) {
        print('Directorio de almacenamiento externo: ${dir.path}');
        var nonbreakable='${DateTime.now().toIso8601String()}-$fileName';

        var file = File('${dir.path}/$nonbreakable');

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        await file.writeAsBytes(bytes!); // Conversión explícita para asegurar que bytes no sea nulo

        imagePaths.add(file.path);
        imageNames.add(nonbreakable);
        print('Archivo guardado correctamente en: ${file.path}');
      } else {
        print('No se pudo obtener el directorio de almacenamiento externo');
      }
    } catch (e) {
      print('Error al guardar el archivo Excel: $e');
    }
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}
