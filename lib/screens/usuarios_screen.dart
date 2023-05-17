import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/models/usuario_model.dart';

class UsuariosScreen extends StatefulWidget {
   
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', email: 'maria@gmail.com', nombre: 'Maria', online: true),
    Usuario(uid: '2', email: 'jose@gmail.com', nombre: 'Jose', online: true),
    Usuario(uid: '3', email: 'carlos@gmail.com', nombre: 'Carlos', online: false),
    Usuario(uid: '4', email: 'gonzalo@gmail.com', nombre: 'Gonzalo', online: true),
    Usuario(uid: '5', email: 'pedro@gmail.com', nombre: 'Pedro', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nombre', style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            
          }, 
          icon: const Icon(Icons.exit_to_app_outlined, color: Colors.black87,)
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color: Colors.blue[400],),
            child: const Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),

      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400]!,
        ),
        child: ListViewUsuarios(usuarios: usuarios)
      ),
    );
  }

  ///  Método para la carga de usuarios
  _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

/// Widget para mostrar lista de usuarios
class ListViewUsuarios extends StatelessWidget {
  const ListViewUsuarios({
    super.key,
    required this.usuarios,
  });

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => UsuarioListTile(usuario: usuarios[index]),
    );
  }
}

/// Widget para mostrar el usuario en el ListTile
class UsuarioListTile extends StatelessWidget {
  const UsuarioListTile({
    super.key,
    required this.usuario,
  });

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0,2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
    );
  }
}