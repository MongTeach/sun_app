import 'dart:convert';

class GalangDanaUser {
  final String id;
  final String idUser;
  final String category;
  final String dataDiri;
  final String penerima;
  final String targetDonasi;
  final String judul;
  final String gambar;
  final String cerita;
  final String status;

  GalangDanaUser({
    required this.id,
    required this.idUser,
    required this.category,
    required this.dataDiri,
    required this.penerima,
    required this.targetDonasi,
    required this.judul,
    required this.gambar,
    required this.cerita,
    required this.status,
  });

  factory GalangDanaUser.fromJson(Map<String, dynamic> json) {
    // Ambil data total_biaya dari target_donasi
    String totalBiaya = json['target_donasi'] != null
        ? jsonDecode(json['target_donasi'])['total_biaya']
        : '';

    // Ambil data total_biaya darij judul
    String datajudul =
        json['judul'] != null ? jsonDecode(json['judul'])['judul'] : '';
    String datagambar =
        json['judul'] != null ? jsonDecode(json['judul'])['image'] : '';

    return GalangDanaUser(
      id: json['id'],
      idUser: json['id_user'].toString(),
      category: json['category'],
      dataDiri: json['data_diri'],
      penerima: json['penerima'],
      targetDonasi: totalBiaya,
      judul: datajudul,
      gambar: datagambar,
      cerita: json['cerita'],
      status: json['status'],
    );
  }
}
