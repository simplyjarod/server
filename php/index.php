<!DOCTYPE html>
<html lang="es">
	<head>
		<meta charset="UTF-8">
		<meta name="robots" content="noindex, follow">
		
		<title>Tible Technologies - Welcome Page</title>

		<link rel='stylesheet' type='text/css' href='http://fonts.googleapis.com/css?family=Exo:400,700'>


		<style type="text/css" media="screen">
			html, body { width:100%; }
			body { background: #FFF; font-family: "Exo", Arial; font-size: 16px; margin: 0; padding: 0; }
			h1 { color: black; }
			a { text-decoration: underline; color: white; }
			a:hover { color: black; }
			p { text-align: justify; text-indent: 1.5em; margin: 0; padding: 0; padding-bottom: 10px; }
		</style>
	</head>

	<body>

		<div style="text-align:center;">
			<img src="https://tibletech.com/img/logo/tible-technologies.png" alt="Logo de Tible Technologies" style="max-width:100%; width:250px; display:inline-block; margin: 25px auto;">
		</div>

		<div style="background: #FF8500; max-width: 100%;">

			<div style="max-width:100%; width: 400px; margin: 15px auto; padding: 15px; color: white;">
				<h1>¡Tu servidor está listo!</h1>
				<p>Puedes acceder por sftp o ssh a tu servidor con los siguientes parámetros de configuración:</p>
				<table style="margin: 15px auto; color:black; font-weight:bold;">
					<tr><td>Host:      </td> <td><?=$_SERVER['HTTP_HOST']?></td></tr>
					<tr><td>Puerto:    </td> <td>22</td></tr>
					<tr><td>Usuario:   </td> <td><?=trim(shell_exec('whoami'))?></td></tr>
					<tr><td>Contraseña:</td> <td>************</td></tr>
				</table>
				<p>Si necesitas que realicemos alguna configuración o tienes alguna consulta, no dudes en contactarnos en <a href="mailto:soporte@tibletech.com">soporte@tibletech.com</a>.</p> 
				
				<br>

				<p style="float: right;">Muchas gracias por tu confianza.</p>
				<p style="float: right; font-style:italic;">El equipo de <a href="https://tibletech.com/es">Tible Technologies</a></p>
				<div style="clear: both;"></div>
			</div>

		</div>

	</body>
</html>
