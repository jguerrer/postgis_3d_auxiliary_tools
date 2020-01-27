--este es el query minimo para poder devolver informacino a potree 
select min(x),min(y),min(z),max(x),max(y),max(z) from tarango where x < 478000;
--esta consulta va a devolver un id, que se usara como data y donde se guardan resultadoa para aceletar