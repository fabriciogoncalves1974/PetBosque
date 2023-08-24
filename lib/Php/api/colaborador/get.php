<?php

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'lista' && $param == ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM colaborador");
     $rs->execute();
        $obj = $rs->fetchAll(PDO::FETCH_ASSOC);

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'lista' && $param == 'ativo'){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM colaborador WHERE  status = '$param'");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}
if($acao == 'lista' && $param == 'inativo'){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM colaborador WHERE status = '$param'");
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
     $rs = $db->prepare("SELECT * FROM colaborador WHERE id={$param}");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}


if($acao == 'ativo' && $param == ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM colaborador WHERE status = 'Ativo'");
     $rs->execute();
        $obj = $rs->fetchAll(PDO::FETCH_ASSOC);

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'quantidade'){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT COUNT(*) FROM colaborador");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

        ?>