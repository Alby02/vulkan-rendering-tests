#include "VulkanEngine.hpp"
#include <print>
#include <exception>

int main(int argc, char* argv[]) {
    try {
        VulkanEngine engine;
        engine.run();
    } catch (const std::exception& e) {
        std::println("Fatal Error: {}", e.what());
        return -1;
    }

    return 0;
}