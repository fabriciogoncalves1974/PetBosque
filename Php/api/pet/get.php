<?php

if($acao == '' && $param == ''){echo json_encode(['ERRO' => 'Caminho nao encontrado!']);exit;}

if($acao == 'lista' && $param == ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM pet");
     $rs->execute();
        $obj = $rs->fetchAll(PDO::FETCH_ASSOC);

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'lista' && $param != ''){
    $db = DB::conexao();
     $rs = $db->prepare("SELECT * FROM pet WHERE id={$param}");
     $rs->execute();
        $obj = $rs->fetchObject();

      if($obj){
       echo json_encode(["dados" => $obj]);
      } else{
        echo json_encode(["dados" => 'Não existe dados para retornar']);
      }
}

if($acao == 'cliente' && $param != ''){
  $db = DB::conexao();
   $rs = $db->prepare("SELECT * FROM pet WHERE idContato ='$param' ");
   $rs->execute();
      $obj = $rs->fetchAll(PDO::FETCH_ASSOC);

    if($obj){
     echo json_encode(["dados" => $obj]);
    } else{
      echo json_encode(["dados" => 'Não existe dados para retornar']);
    }
}
        ?>