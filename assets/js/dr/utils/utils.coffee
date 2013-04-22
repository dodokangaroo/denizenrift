window.requestAnimFrame = (->
  window.requestAnimationFrame or 
  window.webkitRequestAnimationFrame or 
  indow.mozRequestAnimationFrame or 
  window.oRequestAnimationFrame or 
  window.msRequestAnimationFrame or 
  (callback, element) ->
    window.setTimeout callback, 1000 / 60
)()