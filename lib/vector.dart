typedef Vector2 = ({int x, int y});

Vector2 addVector2(Vector2 firstVector, Vector2 secondVector) {
  return (
    x: firstVector.x + secondVector.x,
    y: firstVector.y + secondVector.y,
  );
}
