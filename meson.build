project('vulkan_engine', 'cpp',
  version : '0.1.0',
  default_options : [
    'cpp_std=c++23',
    'warning_level=3',
    'buildtype=debugoptimized'
  ]
)

# --- Dependencies ---
# Meson uses pkg-config to find these on both MSYS2 and Fedora
vulkan_dep = dependency('vulkan')
sdl3_dep = dependency('sdl3')

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
shader_targets = slang_gen.process(
  # Example shaders (create these files in your project, or change the names):
  'shaders/main.vert.slang',
  'shaders/main.frag.slang'
)

# --- C++ Source Files ---
sources = [
  'src/main.cpp',
  'src/VulkanEngine.cpp'
]

compiled_shaders = custom_target('copy_shaders',
  input: shader_targets,
  output: ['main.vert.spv', 'main.frag.spv'],
  command: ['cp', '@INPUT@', '@OUTDIR@'], # 'cp' works in MSYS2 and Fedora
  build_by_default: true
)

# --- Executable ---
executable('vulkan_engine',
  sources,
  compiled_shaders, # Adding shaders here ensures they are compiled before running
  dependencies : [vulkan_dep, sdl3_dep],
  link_args : ['-lstdc++exp'],
  install : true
)