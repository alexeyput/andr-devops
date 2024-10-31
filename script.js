const themeToggler = document.querySelector("#toggle");

themeToggler.addEventListener("click", () => {
  document.body.classList.toggle("dark");
});

const items = [
  {
    title: "Дорожный мотоцикл",
    description: "Geon Scrambler 300",
    tags: ["Топ продаж", "В рассрочку"],
    price: 2400,
    img: "./img/1.jpeg",
    rating: 2.8,
  },
  {
    title: "Дорожный мотоцикл",
    description: "GEON BADDOG 250",
    tags: ["Новинка"],
    price: 1900,
    img: "./img/2.jpeg",
    rating: 4.9,
  },
  {
    title: "Эндуро-кросс, мотард",
    description: "ROTTOR ONYX 300",
    tags: ["Новинка"],
    price: 2628,
    img: "./img/3.jpeg",
    rating: 3.0,
  },
  {
    title: "Туристический мотоцикл",
    description: "KTM ADVENTURE 390",
    tags: ["Топ продаж", "В рассрочку"],
    price: 7640,
    img: "./img/4.jpeg",
    rating: 4.7,
  },
  {
    title: "Спорт",
    description: "VIPER V250-F2",
    tags: ["Топ продаж"],
    price: 1510,
    img: "./img/5.jpeg",
    rating: 4.9,
  },
  {
    title: "Круизер",
    description: "RIDER RENEGADE 250CC",
    tags: ["В рассрочку"],
    price: 1865,
    img: "./img/6.jpeg",
    rating: 3.9,
  },
  {
    title: "Питбайк",
    description: "XTR 607 125CC 14/12",
    tags: ["Новинка"],
    price: 720,
    img: "./img/7.jpeg",
    rating: 5.0,
  },
  {
    title: "Питбайк",
    description: "МИНИ КРОССБАЙК DIRT BIKE DELTA",
    tags: ["Топ продаж"],
    price: 385,
    img: "./img/8.jpeg",
    rating: 3.0,
  },
  {
    title: "Эндуро-кросс, мотард",
    description: "SOKMOTO CRF300CC",
    tags: ["Предзаказ"],
    price: 2780,
    img: "./img/9.jpeg",
    rating: 4.8,
  },
  {
    title: "Спорт",
    description: "ВVOGE 300RR (LONCIN GP300)",
    tags: ["В рассрочку"],
    price: 2640,
    img: "./img/10.jpeg",
    rating: 3.9,
  },
  {
    title: "Туристический мотоцикл",
    description: "SENKE (SKM) SK400-KV",
    tags: ["Предзаказ"],
    price: 5860,
    img: "./img/11.jpeg",
    rating: 4.1,
  },
  {
    title: "Питбайк",
    description: "EXDRIVE BARTON 150",
    tags: ["Топ продаж"],
    price: 1055,
    img: "./img/12.jpeg",
    rating: 3.1,
  },
];

// Товары после применения поиска / фильтров
// которые мы будем показывать пользователю
let currentState = [...items];

// Переменная с контейнером для товаров
const itemsContainer = document.querySelector("#shop-items");
// Шаблон для товара
const itemTemplate = document.querySelector("#item-template");
// Текст, если ничего не найдено
const nothingFound = document.querySelector("#nothing-found");

// Функция для отрисовки
// В качестве параметра — товары, которые нужно отрисовать
function renderItems(arr) {
  // Сбрасываем текст "Ничего не найдено" после предыдущего поиска
  nothingFound.textContent = "";
  // И чистим контейнер с товарами на случай, если там что-то было
  itemsContainer.innerHTML = "";
  // Отрисовываем товары из переданного параметра arr
  arr.forEach((item) => {
    // Вызываем prepareShopItem для каждого товара
    // И подставляем результат в верстку
    itemsContainer.append(prepareShopItem(item));
  });
  // Если массив товаров пустой, отображаем текст, что ничего не нашлось
  if (!arr.length) {
    nothingFound.textContent = "Ничего не найдено";
  }
}

// Функция-хелпер для сортировки товаров по алфавиту
function sortByAlphabet(a, b) {
  // Смотрим на свойство title
  // Если title первого товара алфавитно больше второго...
  if (a.title > b.title) {
    return 1;
  }
  // Если title второго товара больше
  if (a.title < b.title) {
    return -1;
  }
  // Если они равны
  return 0;
}

// Вызываем функцию для отрисовки в самом начале
// И тут же сортируем по алфавиту
renderItems(currentState.sort((a, b) => sortByAlphabet(a, b)));

// Функция для создания верстки конкретного товара
function prepareShopItem(shopItem) {
  // Деструктурируем свойства объекта
  const { title, description, tags, img, price, rating } = shopItem;
  // Берем за основу шаблон товара
  const item = itemTemplate.content.cloneNode(true);
  // Наполняем его информацией из объекта
  item.querySelector("h1").textContent = title;
  item.querySelector("p").textContent = description;
  item.querySelector("img").src = img;
  item.querySelector(".price").textContent = `$${price}`;

  // Находим контейнер для рейтинга
  const ratingContainer = item.querySelector(".rating");
  // Рисуем нужное количество звездочек
  for (let i = 0; i < rating; i++) {
    const star = document.createElement("i");
    star.classList.add("fa", "fa-star");
    ratingContainer.append(star);
  }

  // Находим шаблон для тегов
  const tagsHolder = item.querySelector(".tags");

  // Отрисовываем теги для товара
  tags.forEach((tag) => {
    const element = document.createElement("span");
    element.textContent = tag;
    element.classList.add("tag");
    tagsHolder.append(element);
  });

  // Возвращаем HTML-элемент
  return item;
}

// Инпут для поиска
const searchInput = document.querySelector("#search-input");
// Кнопка
const searchButton = document.querySelector("#search-btn");

// Функция для поиска по товарам (сбрасывает фильтры)
function applySearch() {
  // Взяли значение инпута и "причесали" его
  // Привели к нижнему регистру, чтобы написание не мешало поиску
  const searchString = searchInput.value.trim().toLowerCase();

  // Нашли все товары, в title которых есть searchString
  currentState = items.filter((el) =>
    el.title.toLowerCase().includes(searchString)
  );
  // Отсортировали их по алфавиту
  currentState.sort((a, b) => sortByAlphabet(a, b));
  // Отрисовали результаты поиска
  renderItems(currentState);
  // По умолчанию сортировка "по алфавиту"
  sortControl.selectedIndex = 0;
}

// Обработчик при клике на кнопку поиска
searchButton.addEventListener("click", applySearch);
// Обработчик события поиска при взаимодействии с инпутом
searchInput.addEventListener("search", applySearch);

// Селект с опциями сортировки
const sortControl = document.querySelector("#sort");
// Обработчик события выбора опции из селекта
sortControl.addEventListener("change", (event) => {
  // Атрибут value опции селекта, что выбрал пользователь
  const selectedOption = event.target.value;
  // В зависимости от вида сортировки упорядочиваем массив товаров
  switch (selectedOption) {
    case "expensive": {
      // Сначала дорогие
      currentState.sort((a, b) => b.price - a.price);
      break;
    }
    case "cheap": {
      // Сначала дешевые
      currentState.sort((a, b) => a.price - b.price);
      break;
    }
    case "rating": {
      // От более высокого рейтинга к более низкому
      currentState.sort((a, b) => b.rating - a.rating);
      break;
    }
    case "alphabet": {
      // По алфавиту
      currentState.sort((a, b) => sortByAlphabet(a, b));
      break;
    }
  }
  // Массив упорядочили — осталось его отрисовать
  renderItems(currentState);
});


/*const itemBack = document.createElement("div");
itemBack.classList.add("back");
itemBack.textContent = "Kickstarter.by! За мотоциклами к нам!";*/

items.addEventListener("click", flipCard);
function flipCard() {
  items.classList.toggle("back");
}

