module rip.concepts.destination;

enum Destination {
    Source,
    New
}

static Destination destination = Destination.New;

T setDestination(T) (T data, Destination dest) {
    destination = dest;
    return data;
}

void setDestination(Destination dest) {
    destination = dest;
}
