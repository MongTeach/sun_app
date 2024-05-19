import 'package:flutter/material.dart';

class UrutkanWidget extends StatelessWidget {
  final void Function(String?)? onUrutkanSelected;

  const UrutkanWidget({Key? key, required this.onUrutkanSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: const Color.fromARGB(255, 255, 255, 255), // Ubah warna background
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Ubah warna shadow
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2), // Geser shadow ke bawah
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.filter_list,
            color: Colors.green, // Ubah warna ikon
          ),
          const SizedBox(width: 8.0),
          const Text(
            'Filter',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16, // Ubah ukuran teks
              fontFamily: 'Rubik', // Ganti jenis font
            ),
          ),
          const SizedBox(width: 1.0),
          DropdownButton<String>(
            onChanged: onUrutkanSelected,
            items: const [
              DropdownMenuItem(
                value: 'terbaru',
                child: Text(
                  'Terbaru',
                  style: TextStyle(
                    fontSize: 16, // Ubah ukuran teks
                    color: Colors.black, // Ubah warna teks dropdown item
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'terlama',
                child: Text(
                  'Terlama',
                  style: TextStyle(
                    fontSize: 16, // Ubah ukuran teks
                    color: Colors.black, // Ubah warna teks dropdown item
                  ),
                ),
              ),
            ],
            underline: Container(), // Remove the underline
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black, // Ubah warna ikon dropdown
            ),
            iconSize: 36.0,
            elevation: 16,
            style: const TextStyle(
                color: Colors.black), // Ubah warna teks dropdown
            dropdownColor:
                const Color.fromARGB(255, 255, 255, 255), // Ubah warna dropdown
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}
