<?php 
class DB
{
    public static function conexao()
    {
        $banco = 'petbosque';
        $host = 'petbosque.mysql.dbaas.com.br';
        $usuario = 'petbosque';
        $senha = 'M@ve1974';

        return new PDO("mysql:host={$host};dbname={$banco};",$usuario,$senha);
    }
}


?>