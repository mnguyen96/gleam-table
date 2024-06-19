import gleam/io
import gleam/list
import gleam/string

pub type Table {
  Table(headers: List(String), data: List(List(String)))
}

pub type Row {
  Row(List(String))
}

const middle = "│"

const top = "─"

const top_mid = "┬"

const top_left = "┌"

const top_right = "┐"

const left_mid = "├"

const mid = "─"

const mid_mid = "┼"

const right_mid = "┤"

const bottom = "─"

const bottom_mid = "┴"

const bottom_left = "└"

const bottom_right = "┘"

pub fn render(table: Table, col_width: Int) {
  render_top_line(table.headers, col_width)
  render_headers(table.headers, col_width)
  render_rows(table.data, col_width)
  render_bottom_line(table.headers, col_width)
}

fn render_headers(headers: List(String), col_width) {
  case headers {
    [] -> io.println(middle)
    [x] -> {
      io.print(middle)
      io.print(trim_data(x, col_width))
      render_headers([], col_width)
    }
    [x, ..rest] -> {
      io.print(middle)
      io.print(trim_data(x, col_width))
      render_headers(rest, col_width)
    }
  }
}

fn render_rows(rows: List(List(String)), col_width) {
  list.each(rows, fn(x) {
    render_mid_line(x, col_width)
    render_cells(x, col_width)
  })
}

fn render_cells(cells: List(String), col_width) {
  case cells {
    [] -> io.println(middle)
    [x] -> {
      io.print(middle)
      io.print(trim_data(x, col_width))
      render_cells([], col_width)
    }
    [x, ..rest] -> {
      io.print(middle)
      io.print(trim_data(x, col_width))
      render_cells(rest, col_width)
    }
  }
}

fn trim_data(data: String, length) {
  string.pad_right(string.slice(data, 0, length), length, " ")
}

fn render_top_line(headers: List(String), col_width) {
  io.println(
    top_left
    <> string.repeat(top, col_width)
    <> string.repeat(
      top_mid <> string.repeat(top, col_width),
      list.length(headers) - 1,
    )
    <> top_right,
  )
}

fn render_mid_line(row: List(String), col_width) {
  io.println(
    left_mid
    <> string.repeat(mid, col_width)
    <> string.repeat(
      mid_mid <> string.repeat(mid, col_width),
      list.length(row) - 1,
    )
    <> right_mid,
  )
}

fn render_bottom_line(row: List(String), col_width) {
  io.println(
    bottom_left
    <> string.repeat(bottom, col_width)
    <> string.repeat(
      bottom_mid <> string.repeat(bottom, col_width),
      list.length(row) - 1,
    )
    <> bottom_right,
  )
}

pub fn main() {
  let table =
    Table(["header1", "header2", "header3"], [["data1", "data2", "data3"]])
  render(table, 10)
}
