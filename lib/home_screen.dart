import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_nineth_project/api_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final snapshot = ref.watch(apiProvider);
          ref.listen(apiProvider, (_, next) {
            next.whenOrNull(
              error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              ),
            );
          });

          return snapshot.when(
            skipLoadingOnReload: false,
            data: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        post.title.toString(),
                        maxLines: 1 ,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body.toString().replaceAll('\n', ' '),
                            style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                      onPressed: () {
                        ref.invalidate(apiProvider);
                      },
                      child: Text('Retry'))
                ],
              ),
            ),
            loading: () => Center(child: const CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
