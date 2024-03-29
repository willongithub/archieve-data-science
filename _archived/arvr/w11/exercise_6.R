require(aframer)
require(arframer)

# generate html element
embed_aframe(
    a_scene(
        a_dependency(),
        a_box(position = "-1 0.5 -3", rotation = "0 45 0", color = "#4CC3D9"),
        a_sphere(position = "0 1.25 -5", radius = "1.25", color = "#EF2D5E"),
        a_cylinder(position = "1 0.75 -3", radius = "0.5", height = "1.5", color = "#FFC65D"),
        a_plane(position = "0 0 -4", rotation = "-90 0 0", width = "4", height = "4", color = "#7BC8A4"),
        a_sky(color="#ECECEC")
    )
)

# runs in the browser
broswe_aframe(
    a_scene(
        a_dependency(),
        a_box(position = "-1 0.5 -3", rotation = "0 45 0", color = "#4CC3D9"),
        a_sphere(position = "0 1.25 -5", radius = "1.25", color = "#EF2D5E"),
        a_cylinder(position = "1 0.75 -3", radius = "0.5", height = "1.5", color = "#FFC65D"),
        a_plane(position = "0 0 -4", rotation = "-90 0 0", width = "4", height = "4", color = "#7BC8A4"),
        a_sky(color="#ECECEC")
    )
) 