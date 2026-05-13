project('vulkan_engine', 'cpp',
  version : '0.1.0',
  default_options : [
    'cpp_std=c++23,c++latest',
    'warning_level=3',
    'buildtype=debugoptimized'
  ]
)

# --- Dependencies ---
# Meson natively finds Vulkan via pkg-config or VULKAN_SDK environment variable
vulkan_dep = dependency('vulkan')

# Try standard dependency resolution first (pkg-config, CMake)
sdl3_dep = dependency('sdl3', required: false)
glm_dep = dependency('glm', required: false)

cpp = meson.get_compiler('cpp')

# Fallback for Windows MSVC: LunarG SDK often bundles SDL3 and GLM
if cpp.get_id() == 'msvc' and (not sdl3_dep.found() or not glm_dep.found())
  
  # Retrieve the VULKAN_SDK environment variable via Python (which Meson guarantees is present)
  python = find_program('python', 'python3')
  vulkan_sdk_path = run_command(python, '-c', 'import os; print(os.environ.get("VULKAN_SDK", ""))', check: false).stdout().strip()
  
  if vulkan_sdk_path != ''
    if not sdl3_dep.found()
      sdl3_lib = cpp.find_library('SDL3', dirs: vulkan_sdk_path / 'Lib', required: true)
      sdl3_dep = declare_dependency(include_directories: vulkan_sdk_path / 'Include', dependencies: sdl3_lib)
    endif
    if not glm_dep.found()
      glm_dep = declare_dependency(include_directories: vulkan_sdk_path / 'Include')
    endif
  endif
endif

# If still missing, trigger typical dependency() to fail with a proper native error
if not sdl3_dep.found()
  sdl3_dep = dependency('sdl3')
endif
if not glm_dep.found()
  glm_dep = dependency('glm')
endif

# --- Shader Compilation Setup ---
# Find the Slang compiler on the system PATH
slangc = find_program('slangc', required: true)

# Create a generator for Slang shaders
# This tells Meson how to turn any .slang file into a .spv (SPIR-V) file
slang_gen = generator(slangc,
  output  : '@BASENAME@.spv',
  arguments : ['@INPUT@', '-target', 'spirv', '-profile', 'glsl_450', '-o', '@OUTPUT@']
)

# List your shader files here
# Meson will compile them and place the .spv files in your build directory
# Process all shaders through the generator
shader_targets = slang_gen.process(
  'shaders/main.vert.slang',
  'shaders/main.frag.slang'
)

# --- C++ Source Files ---
sources = [
  'src/main.cpp',
  'src/VulkanEngine.cpp'
]

# Copy shaders to builddir root so the executable can find them at runtime
# Python is guaranteed to be available in Meson environments, making this cross-platform
compiled_shaders = custom_target('copy_shaders',
  input: shader_targets,
  output: ['main.vert.spv', 'main.frag.spv'],
  command: [
    find_program('python', 'python3'), '-c',
    'import shutil, sys; shutil.copy(sys.argv[1], sys.argv[3]); shutil.copy(sys.argv[2], sys.argv[4])',
    '@INPUT0@', '@INPUT1@', '@OUTPUT0@', '@OUTPUT1@'
  ],
  build_by_default: true
)

# --- Executable ---
link_args = []
if cpp.get_id() != 'msvc'
  link_args += '-lstdc++exp'
endif

# Simply pass the generator targets to the executable
executable('vulkan_engine',
  sources,
  compiled_shaders,
  dependencies : [vulkan_dep, sdl3_dep, glm_dep],
  link_args : link_args,
  install : true
)