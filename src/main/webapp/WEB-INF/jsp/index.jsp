<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>GoodEarth — Splash Screen</title>

  <style>
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #0a0618; /* Dark background like your image */
      overflow: hidden;
    }

    .logo-container {
      opacity: 0;
      transform: translateY(100px);
      animation: slideUp 2s ease-out forwards;
    }

    @keyframes slideUp {
      0% {
        opacity: 0;
        transform: translateY(100px);
      }
      100% {
        opacity: 1;
        transform: translateY(0);
      }
    }

    img {
      width: 25vw;
      max-width: 300px;
      height: auto;
      display: block;
      margin: 0 auto;
    }

    .text {
      color: white;
      text-align: center;
      font-family: "Poppins", sans-serif;
      margin-top: 12px;
      font-size: 14px;
      letter-spacing: 1px;
    }

    .loader {
      border: 4px solid rgba(255, 255, 255, 0.2);
      border-top: 4px solid #fff;
      border-radius: 50%;
      width: 2.5rem;
      height: 2.5rem;
      animation: spin 1s linear infinite;
      margin: 2rem auto 0;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    
    @media(max-width:640px){
       .logo-container img {
         width: 70vw;
       }
    }
  </style>

  <script>
  // Redirect to user login page after 4 seconds
  setTimeout(function() {
    window.location.href = "${pageContext.request.contextPath}/manage";
  }, 4000);
</script>

</head>

<body>
  <div class="logo-container">
    <img src="${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg" alt="GoodEarth Logo" />
    <div class="loader"></div>
    <div class="text">Loading... Please wait</div>
  </div>
</body>
</html>
