window.addEventListener('message', function(event) {
    if (event.data.type === 'openBossMenu') {
        document.getElementById('bossMenu').style.display = 'block';
        loadEmployees(event.data.employees);
    }
});

function loadEmployees(employees) {
    const employeeList = document.getElementById('employeeList');
    employeeList.innerHTML = '';
    employees.forEach(employee => {
        const div = document.createElement('div');
        div.innerHTML = `
            <p>${employee.name} - ${employee.grade}</p>
            <button onclick="promote('${employee.id}')">Promote</button>
            <button onclick="demote('${employee.id}')">Demote</button>
        `;
        employeeList.appendChild(div);
    });
}

function promote(employeeId) {
    fetch(`https://${GetParentResourceName()}/promoteEmployee`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ employeeId })
    });
}

function demote(employeeId) {
    fetch(`https://${GetParentResourceName()}/demoteEmployee`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ employeeId })
    });
}

function closeMenu() {
    document.getElementById('bossMenu').style.display = 'none';
}