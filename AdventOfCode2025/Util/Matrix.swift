import Vector2

struct Matrix<T> {
    let rows: Int
    let columns: Int
    var data: [T]
    
    init(rows: Int, columns: Int, initial: T) {
        self.rows = rows
        self.columns = columns
        self.data = [T](repeating: initial, count: rows * columns)
    }
    
    subscript (x: Int, y: Int) -> T? {
        get {
            if x < 0 || x >= columns || y < 0 || y >= rows { return nil }
            return data[y * columns + x]
        }
        set {
            guard let newValue else { return }
            if x < 0 || x >= columns || y < 0 || y >= rows { return }
            data[y * columns + x] = newValue
        }
    }
    
    subscript (vector: IntVector2) -> T? {
        get {
            self[vector.x, vector.y]
        }
        set {
            self[vector.x, vector.y] = newValue
        }
    }
}

struct DefaultingMatrix<T> {
    var grid: Matrix<T>
    let defaultValue: T
    
    init(rows: Int, columns: Int, initial: T, default: T) {
        grid = Matrix(rows: rows, columns: columns, initial: initial)
        defaultValue = `default`
    }
    
    subscript (x: Int, y: Int) -> T {
        get {
            grid[x, y] ?? defaultValue
        }
        set {
            grid[x, y] = newValue
        }
    }
    
    subscript (vector: IntVector2) -> T {
        get {
            self[vector.x, vector.y]
        }
        set {
            self[vector.x, vector.y] = newValue
        }
    }
}
