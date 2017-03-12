/* use cheerio to read html files on stdin, strip out #header, then write to stdout */

let cheerio = require('cheerio')

var html = ""

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    html += chunk
  }
});

process.stdin.on('end', () => {
  let $ = cheerio.load(html)
  $('#header').remove()
  $('.info').remove()
  $('#footer').remove()
  $('#content').children().each(function(i, el) {
    $('body').append(el)
  })
  $('#content').remove()

  process.stdout.write($.html());
});
