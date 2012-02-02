// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('document').ready(function(){
  var r = Raphael("holder")

  r.dotchart(0, 0, 1000, 800, which_day, which_habit, results, {symbol: "0", max: 10, heat: true, axis: "0 0 1 1", axisxstep: dates.length-1, axisystep: habits.length-1, axisxlabels: dates, axisxtype: " ", axisytype: " ", axisylabels: habits}).hover(function () {
      this.marker = this.marker || r.tag(this.x, this.y, this.value, 0, this.r + 2).insertBefore(this);
      this.marker.show();
  }, function () {
      this.marker && this.marker.hide();
  });

  $('svg').attr('width', 1000).attr('height', 800);
})     