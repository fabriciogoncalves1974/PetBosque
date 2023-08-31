<?php

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}
if($acao == 'colaborador' && $param == ''){echo json_encode(["dados" => 'Não existe dados para retornar']);exit;}

if($acao == 'lista' && $param == ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM agendamento");
     $rs->execute();
        $obj = $rs->fetchAll(PDO::FETCH_ASSOC);

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'lista' && $param == 'pendente'){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM agendamento WHERE  status = '$param'");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}
if($acao == 'colaborador' && $param != ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM agendamento WHERE idColaborador = '$param'");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

//Verifica se parametro é um numero

if($acao == 'lista' && $param != '' && preg_match('/\d/', $param) === 1){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM agendamento WHERE id={$param}");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}



if($acao == 'quantidade'){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT COUNT(*) FROM agendamento");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'total' && $param != ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT SUM(valorTotal) as total FROM agendamento WHERE idColaborador = '$param'");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}
if($acao == 'total' && $param == ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT SUM(valorTotal) as total FROM agendamento ");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

        ?>