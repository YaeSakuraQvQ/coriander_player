import 'package:coriander_player/app_settings.dart';
import 'package:coriander_player/library/playlist.dart';
import 'package:coriander_player/lyric/lyric_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:window_manager/window_manager.dart';

class NowPlayingPageTitleBar extends StatelessWidget {
  const NowPlayingPageTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(
          height: 48.0,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: SizedBox.expand())),
              WindowControlls(),
            ],
          ),
        ),
        SizedBox(
          height: 32.0,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: context.pop,
              child: Center(
                child: Icon(
                  Symbols.arrow_drop_down,
                  color: scheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class WindowControlls extends StatefulWidget {
  const WindowControlls({super.key});

  @override
  State<WindowControlls> createState() => _WindowControllsState();
}

class _WindowControllsState extends State<WindowControlls> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }

  @override
  void onWindowRestore() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: windowManager.minimize,
            icon: const Icon(Symbols.remove),
          ),
          const SizedBox(width: 8.0),
          FutureBuilder(
            future: windowManager.isMaximized(),
            builder: (context, snapshot) {
              final isMaximized = snapshot.data ?? false;
              return IconButton(
                onPressed: isMaximized
                    ? windowManager.unmaximize
                    : windowManager.maximize,
                icon: Icon(
                  isMaximized ? Symbols.fullscreen_exit : Symbols.fullscreen,
                ),
              );
            },
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () async {
              await savePlaylists();
              await saveLyricSources();
              await AppSettings.instance.saveSettings();
              windowManager.close();
            },
            icon: const Icon(Symbols.close),
          ),
        ],
      ),
    );
  }
}
