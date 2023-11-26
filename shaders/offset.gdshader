shader_type canvas_item;

uniform vec2 percent;
void vertex(){
	VERTEX.x += percent.x;
	VERTEX.y += percent.y;
}