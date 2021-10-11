require(aframer)
require(arframer)

browse_aframe(
    ar_scene(
        a_box(position = "0 0.5 0", material = "opacity: 0.5;"),
        a_primitive("marker-camera", list(preset = "hiro"))
    )
) 