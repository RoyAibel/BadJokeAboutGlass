// ECS-style hydration system

struct ThirstyComponent {};
struct VolumeComponent { float volume = 0; float max = 100; };
struct InternComponent {};

struct DrinkSystem {
    void update(entt::registry& reg) {
        auto view = reg.view<ThirstyComponent, VolumeComponent>();
        for (auto entity : view) {
            auto& vol = view.get<VolumeComponent>(entity);
            if (vol.volume > 0) {
                vol.volume -= 10;
            }
            reg.remove<ThirstyComponent>(entity);
        }
    }
};

struct FillSystem {
    void update(entt::registry& reg) {
        auto view = reg.view<ThirstyComponent, VolumeComponent>();
        for (auto entity : view) {
            auto& vol = view.get<VolumeComponent>(entity);
            if (vol.volume == 0) {
                vol.volume = vol.max;
            }
        }
    }
};

int main() {
    entt::registry reg;

    auto user = reg.create();
    reg.emplace<ThirstyComponent>(user);
    reg.emplace<VolumeComponent>(user);

    DrinkSystem drink;
    FillSystem fill;

    for (int i = 0; i < 8; ++i) {
        drink.update(reg);
        fill.update(reg);

        reg.emplace_or_replace<ThirstyComponent>(user); // get thirsty again
        std::this_thread::sleep_for(std::chrono::minutes(1));
    }
}
