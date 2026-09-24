import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../core/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    final user = controller.currentUser;

    return SafeArea(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            user?.email ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.primary),
                  title: const Text("Se déconnecter"),
                  onTap: () async {
                    await controller.signOut();
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: AppColors.expenseRed,
                  ),
                  title: const Text(
                    "Supprimer mon compte",
                    style: TextStyle(color: AppColors.expenseRed, fontSize: 14),
                  ),
                  onTap: controller.isLoading
                      ? null
                      : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Supprimer le compte"),
                              content: const Text(
                                "Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Vos données seront effacées et cette action est irréversible.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Annuler"),
                                ),
                                const SizedBox(width: 70),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.expenseRed,
                                  ),
                                  child: const Text("Supprimer"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && context.mounted) {
                            final success = await controller.deleteAccount();
                            if (!success &&
                                context.mounted &&
                                controller.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(controller.errorMessage!),
                                  backgroundColor: AppColors.expenseRed,
                                ),
                              );
                            }
                          }
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
