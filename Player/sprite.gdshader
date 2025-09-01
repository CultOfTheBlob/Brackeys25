shader_type canvas_item;

uniform bool toggle = false;

void fragment() {
  if (toggle) {
    COLOR = vec4(1, 1, 1, 1) * COLOR.a;
  }
}
