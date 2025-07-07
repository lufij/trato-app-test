import 'dart:typed_data';
import 'dart:convert'; // Para base64Encode
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/post_service.dart';
import '../services/auth_service.dart';
import '../services/local_database_service.dart';
import '../services/storage_service.dart';
import '../services/persistence_mode.dart';
import '../theme/app_theme.dart';

// Solo para web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io' as io;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagController = TextEditingController();

  final _postService = PostService();
  final _authService = AuthService();

  PostType _selectedPostType = PostType.offer;
  String _selectedCategory = 'General';
  bool _isPublishing = false;
  String? _errorMessage;
  bool _showPreview = false;
  bool _showRestoreDraft = false;
  final List<String> _tags = [];
  final List<String> _suggestedTags = [
    'Nuevo', 'Usado', 'Oferta', 'Urgente', 'Intercambio', 'Popular', 'Descuento', 'Garantía', 'Edición limitada', 'Sostenible'
  ];
  final List<String> _categories = [
    'General', 'Agricultura', 'Ganadería', 'Pesca', 'Tecnología', 'Servicios'
  ];
  Map<String, dynamic>? _draft;

  final List<_LocalImage> _localImages = [];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    // Login local automático para asegurar usuario válido
    _authService.login('guichointeriano@yahoo.com', 'Foto2301');
  }

  void _saveDraft() {
    _draft = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category': _selectedCategory,
      'type': _selectedPostType,
      'tags': List<String>.from(_tags),
      'localImages': _localImages.map((e) => e.toMap()).toList(),
    };
    setState(() {
      _showRestoreDraft = true;
    });
  }

  void _loadDraft() {
    if (_draft != null) {
      _titleController.text = _draft!['title'] ?? '';
      _descriptionController.text = _draft!['description'] ?? '';
      _priceController.text = _draft!['price'] ?? '';
      _selectedCategory = _draft!['category'] ?? 'General';
      _selectedPostType = _draft!['type'] ?? PostType.offer;
      _tags.clear();
      _tags.addAll(List<String>.from(_draft!['tags'] ?? []));
      _localImages.clear();
      if (_draft!['localImages'] != null) {
        _localImages.addAll(List<Map<String, dynamic>>.from(_draft!['localImages']).map((e) => _LocalImage.fromMap(e)));
      }
      setState(() {});
    }
  }

  void _clearDraft() {
    _draft = null;
    setState(() {
      _showRestoreDraft = false;
    });
  }

  // Métodos para gestión de etiquetas (tags)
  void _addTag(String tag) {
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() {
      _tags.add(tag);
      _tagController.clear();
      _saveDraft();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _saveDraft();
    });
  }

  Future<void> _publishPost() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Por favor completa todos los campos obligatorios.';
      });
      return;
    }
    final UserModel? currentUser = _authService.currentUser;
    if (currentUser == null) {
      setState(() {
        _errorMessage = 'Debes iniciar sesión para publicar.';
      });
      return;
    }
    final userId = (currentUser.id.isNotEmpty ? currentUser.id : 'usuario_local');
    final userDisplayName = (currentUser.name != null && currentUser.name.isNotEmpty) ? currentUser.name : 'Usuario Anónimo';
    final userAvatarUrl = currentUser.profileImage ?? '';
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final category = _selectedCategory.isNotEmpty ? _selectedCategory : 'General';
    final type = _selectedPostType;
    if (title.isEmpty || description.isEmpty || category.isEmpty || type == null) {
      setState(() {
        _errorMessage = 'Completa todos los campos requeridos.';
      });
      return;
    }
    setState(() {
      _isPublishing = true;
      _errorMessage = null;
    });
    try {
      final isFirebase = PersistenceConfig.mode == PersistenceMode.firebase;
      List<String> imageUrls = [];
      if (isFirebase && _localImages.isNotEmpty) {
        // Subir imágenes a Firebase Storage
        final storageService = StorageService();
        for (final img in _localImages) {
          if (img.dataUrl != null) {
            final base64Str = img.dataUrl!.split(',').last;
            final bytes = base64Decode(base64Str);
            final url = await storageService.uploadImage(bytes, '${DateTime.now().millisecondsSinceEpoch}_${img.name}');
            imageUrls.add(url);
          }
        }
      } else {
        imageUrls = _localImages.map((e) => e.dataUrl ?? '').toList();
      }
      final newPost = PostModel(
        userId: userId,
        userDisplayName: userDisplayName,
        userAvatarUrl: userAvatarUrl.isNotEmpty ? userAvatarUrl : null,
        title: title,
        description: description,
        imageUrls: imageUrls,
        category: category,
        type: type,
        price: _priceController.text.trim().isNotEmpty ? double.tryParse(_priceController.text.trim()) : null,
        createdAt: DateTime.now(),
        likesCount: 0,
        handshakes: 0,
      );
      if (isFirebase) {
        await _postService.createPost(newPost);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.cloud_done, color: Colors.white),
                  SizedBox(width: 8),
                  Text('¡Publicación guardada en la nube!'),
                ],
              ),
              backgroundColor: AppTheme.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await LocalDatabaseService.addPost(newPost);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('¡Publicación guardada localmente!'),
                ],
              ),
              backgroundColor: AppTheme.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
      _clearDraft();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al publicar: $e';
      });
    } finally {
      setState(() {
        _isPublishing = false;
      });
    }
  }

  void _togglePreview() {
    setState(() {
      _showPreview = !_showPreview;
    });
  }

  void _showImagePreview(String dataUrl) {
    if (dataUrl.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.network(dataUrl, fit: BoxFit.contain),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Publicación'),
        actions: [
          IconButton(
            tooltip: _showPreview ? 'Cerrar vista previa' : 'Vista previa',
            icon: Icon(_showPreview ? Icons.visibility_off : Icons.visibility),
            onPressed: _togglePreview,
          ),
          if (_showRestoreDraft)
            IconButton(
              tooltip: 'Restaurar borrador',
              icon: const Icon(Icons.restore),
              onPressed: _loadDraft,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _isPublishing
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : TextButton(
                    onPressed: _publishPost,
                    child: const Text(
                      'Publicar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: _showPreview ? _buildPreview() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      onChanged: _saveDraft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Detalles de la Publicación'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título', helperText: 'Sé claro y descriptivo'),
              validator: (value) => value!.isEmpty ? 'El título es requerido' : null,
              maxLength: 60,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción', helperText: 'Describe tu producto o servicio'),
              maxLines: 5,
              maxLength: 500,
              validator: (value) => value!.isEmpty ? 'La descripción es requerida' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Clasificación'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<PostType>(
                    value: _selectedPostType,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: PostType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedPostType = value);
                        _saveDraft();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: _categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                        _saveDraft();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio (Opcional)',
                prefixText: 'Q ',
                helperText: 'Deja vacío si es un intercambio o donación',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Etiquetas'),
            const SizedBox(height: 8),
            _buildTagInput(),
            const SizedBox(height: 24),
            _buildSectionTitle('Imágenes'),
            const SizedBox(height: 16),
            _buildImageUrlInput(),
            const SizedBox(height: 24),
            if (_errorMessage != null) ...[
              AnimatedOpacity(
                opacity: _errorMessage != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppTheme.errorRed),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _isPublishing ? null : _publishPost,
              icon: const Icon(Icons.publish),
              label: const Text('Publicar Ahora'),
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_titleController.text, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(_descriptionController.text, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
              const SizedBox(height: 12),
              Text('Categoría: $_selectedCategory'),
              Text('Tipo: ${_selectedPostType.name}'),
              if (_priceController.text.isNotEmpty)
                Text('Precio: Q ${_priceController.text}'),
              const SizedBox(height: 16),
              if (_localImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _localImages.map((img) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(img.dataUrl ?? '', width: 100, height: 100, fit: BoxFit.cover),
                    )).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.elegantGray,
              ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: _getSectionHelp(title),
          child: const Icon(Icons.help_outline, size: 18, color: AppTheme.elegantGray),
        ),
      ],
    );
  }

  String _getSectionHelp(String section) {
    switch (section) {
      case 'Detalles de la Publicación':
        return 'Incluye un título y descripción claros para atraer más interesados.';
      case 'Clasificación':
        return 'Selecciona el tipo y la categoría que mejor describen tu publicación.';
      case 'Etiquetas':
        return 'Agrega palabras clave para mejorar la visibilidad.';
      case 'Imágenes':
        return 'Añade imágenes desde tu dispositivo.';
      default:
        return '';
    }
  }

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: _tags.map((tag) => Chip(
            label: Text(tag),
            onDeleted: () => _removeTag(tag),
          )).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: 'Agregar etiqueta',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addTag(_tagController.text.trim()),
                  ),
                ),
                onSubmitted: (value) => _addTag(value.trim()),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.tag),
              tooltip: 'Sugerencias',
              onSelected: _addTag,
              itemBuilder: (context) => _suggestedTags
                  .where((t) => !_tags.contains(t))
                  .map((tag) => PopupMenuItem(value: tag, child: Text(tag)))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: _localImages.isEmpty
              ? Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined, size: 40),
                    tooltip: 'Seleccionar imagen',
                    onPressed: _pickLocalImage,
                  ),
                )
              : ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex >= 0 && newIndex >= 0 && oldIndex < _localImages.length && newIndex < _localImages.length) {
                      setState(() {
                        final img = _localImages.removeAt(oldIndex);
                        _localImages.insert(newIndex, img);
                        _saveDraft();
                      });
                    }
                  },
                  children: [
                    for (int i = 0; i < _localImages.length; i++)
                      _buildLocalImageThumbnail(_localImages[i], i),
                    if (_localImages.length < 5)
                      Padding(
                        key: const ValueKey('add_more'),
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.add_photo_alternate_outlined, size: 40),
                          tooltip: 'Agregar imagen',
                          onPressed: _pickLocalImage,
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        Text(
          'Agrega hasta 5 imágenes desde tu dispositivo. Arrastra para reordenar.',
          style: const TextStyle(color: AppTheme.elegantGray, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLocalImageThumbnail(_LocalImage img, int index) {
    return Padding(
      key: ValueKey(img.dataUrl ?? img.name),
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _showImagePreview(img.dataUrl ?? ''),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                img.dataUrl ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeLocalImage(img),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickLocalImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        final file = input.files?.first;
        if (file != null) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) {
            setState(() {
              if (_localImages.length < 5) {
                _localImages.add(_LocalImage(
                  dataUrl: reader.result as String,
                  name: file.name,
                ));
                _saveDraft();
              }
            });
          });
        }
      });
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageData = await pickedFile.readAsBytes();
        setState(() {
          if (_localImages.length < 5) {
            _localImages.add(_LocalImage(
              dataUrl: 'data:image/jpeg;base64,${base64Encode(imageData)}',
              name: pickedFile.name,
            ));
            _saveDraft();
          }
        });
      }
    }
  }

  void _removeLocalImage(_LocalImage img) {
    setState(() {
      _localImages.remove(img);
      _saveDraft();
    });
  }
}

class _LocalImage {
  final String? dataUrl; // base64 para web
  final String name;
  _LocalImage({this.dataUrl, required this.name});

  Map<String, dynamic> toMap() => {'dataUrl': dataUrl, 'name': name};
  factory _LocalImage.fromMap(Map<String, dynamic> map) => _LocalImage(dataUrl: map['dataUrl'], name: map['name']);
}
