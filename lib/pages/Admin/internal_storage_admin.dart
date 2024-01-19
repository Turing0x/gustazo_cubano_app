import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class InternalStoragePage extends StatefulWidget {
  const InternalStoragePage({super.key});

  @override
  State<InternalStoragePage> createState() => _InternalStoragePageState();
}

class _InternalStoragePageState extends State<InternalStoragePage> {
  bool alternar = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: showAppBar('Almacenamiento interno', actions: [
        IconButton(
            icon: const Icon(
              Icons.folder_delete_outlined,
              color: Colors.white,
            ),
            onPressed: () async{
              Directory? appDocDirectory =
                  await getExternalStorageDirectory();
              final filePath = Directory(appDocDirectory!.path);

              filePath.deleteSync(recursive: true);

              showToast('Todo los documentos fueron eliminados',
                  type: true);
              navigator.pop();
              cambioListas.value = !cambioListas.value;
            }
        )
      ]),
      body: SizedBox(
        height: size.height * 0.7,
        width: double.infinity,
        child: showFolderList(size)),
    );
  }

  ValueListenableBuilder<bool> showFolderList(Size size) {
    return ValueListenableBuilder(
      valueListenable: cambioListas,
      builder: (context, value, child) => FutureBuilder(
        future: getDirectoryOfPdf(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context, 'Sin datos');
          }

          List<dynamic> list = snapshot.data!;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final color =
                    (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];

                return ListTile(
                  tileColor: color,
                  minLeadingWidth: 20,
                  title: dosisText(list[index].split('/')[9], size: 20,
                      fontWeight: FontWeight.bold),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      openFile(list[index]),
                      deleteFile(list[index])
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List> getDirectoryOfPdf() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      if( !Directory('${appDocDirectory?.path}/PDFDocs').existsSync() ) return [];

      final dir = Directory('${appDocDirectory?.path}/PDFDocs');
      if( dir.existsSync() ){

        final fileList = Directory('${appDocDirectory?.path}/PDFDocs').listSync();
        
        for (var file in fileList) {
          paths.add(file.path);
        }

      }

      return paths;
    } catch (e) {
      return [];
    }
  }

  IconButton openFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.remove_red_eye_outlined,
          color: Colors.green,
        ),
        onPressed: () => OpenFile.open(path, type: 'application/pdf'));
  }

  IconButton deleteFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
        ),
        onPressed: () {
          final file = File(path);
          try {
            file.deleteSync();
            showToast('Documento eliminado exitosamente', type: true);
            cambioListas.value = !cambioListas.value;
          } catch (e) {
            showToast('No se pudo eliminar el documento');
          }
        });
  }

  IconButton deleteFolder(String path) {
    return IconButton(
        icon:
            const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
        onPressed: () {
          final folder = Directory(path);
          try {
            folder.deleteSync(recursive: true);
            showToast('Documento eliminado exitosamente', type: true);
            cambioListas.value = !cambioListas.value;
            Navigator.pop(context);
          } catch (e) {
            showToast('No se pudo eliminar el documento');
          }
        });
  }
}
